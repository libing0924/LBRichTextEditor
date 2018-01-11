//
//  LBEditorViewController.m
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/10.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import "LBEditorViewController.h"
#import "ZSSTextView.h"
#import "LBEditorMessageHelper.h"
#import "UIWebView+HackishAccessoryHiding.h"

@interface LBEditorViewController ()<LBEditorMessageDelegate>

@property (nonatomic, strong, readwrite) NSNumber *caretYOffset;
@property (nonatomic, strong, readwrite) NSNumber *lineHeight;
@property (nonatomic, assign, readwrite) NSInteger lastEditorHeight;

// 编辑工具栏
@property (nonatomic, strong) LBEditorToolBar *toolBar;

// 显示HTML源码的view层
@property (nonatomic, strong) ZSSTextView *sourceView;

// 文本编辑器
@property (nonatomic, strong) UIWebView *editorView;

// native和编辑器JS交互工具
@property (nonatomic, strong) LBEditorMessageHelper *messageHelper;

@end

@implementation LBEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSourceView];
    
    [self createEditorView];
    
    [self createToolBar];
    
    [self createJavaScriptBridge];
    
    [self loadResource];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)createSourceView {
    
    self.sourceView = [[ZSSTextView alloc] initWithFrame:self.view.bounds];
    self.sourceView.hidden = YES;
    self.sourceView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.sourceView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.sourceView.font = [UIFont fontWithName:@"Courier" size:13.0];
    self.sourceView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.sourceView.autoresizesSubviews = YES;
    self.sourceView.delegate = self;
    [self.view addSubview:self.sourceView];
    
}

- (void)createEditorView {
    
    self.editorView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.editorView.delegate = self;
    self.editorView.hidesInputAccessoryView = YES;
    self.editorView.keyboardDisplayRequiresUserAction = NO;
    self.editorView.scalesPageToFit = YES;
    self.editorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.editorView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.editorView.scrollView.bounces = NO;
    self.editorView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.editorView];
    
}

- (void)createToolBar {
    
    self.toolBar = [self loadToolBar];
    
    [self.view addSubview:self.toolBar];
}

- (LBEditorToolBar *)loadToolBar {
    
    NSMutableArray *items = [NSMutableArray new];
    NSArray *normalImages = @[@"ZSSbold", @"ZSSunderline", @"ZSStextcolor", @"ZSSbgcolor", @"ZSSfonts", @"ZSSimageDevice", @"ZSSleftjustify", @"ZSScenterjustify", @"ZSSrightjustify"];
    
    for (int i = 0; i < 9; i++)
    {
        UIImage *normalImage = [UIImage imageNamed:normalImages[i]];
        UIImage *selectedImage = [UIImage imageNamed:@""];
        LBEditorToolBarButton *button = [[LBEditorToolBarButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40) normalImage:normalImage selectedImage:selectedImage type:i];
        [items addObject:button];
    }
    __weak typeof(self) weakSelf= self;
    LBEditorToolBar *toolBar = [[LBEditorToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40) items:items.copy callBack:^(JSMessageType type) {
        
        // 工具栏消息
        [weakSelf.messageHelper handleJSMessage:type];
    }];
    
    return toolBar;
}

- (void)createJavaScriptBridge {
    
    self.messageHelper = [LBEditorMessageHelper defaultBrige:self.editorView];
    self.messageHelper.editDelegate = self;
}

- (void)loadResource {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *editorURL = [bundle URLForResource:@"editor" withExtension:@"html"];
    [self.editorView loadRequest:[NSURLRequest requestWithURL:editorURL]];
    
}

- (void)keyboardWillShowOrHide:(NSNotification *)notification {
    
    // Orientation
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // User Info
    NSDictionary *info = notification.userInfo;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    int curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGRect keyboardEnd = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // Keyboard Size
    //Checks if IOS8, gets correct keyboard height
    CGFloat keyboardHeight = UIInterfaceOrientationIsLandscape(orientation) ? ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.000000) ? keyboardEnd.size.height : keyboardEnd.size.width : keyboardEnd.size.height;
    // 匹配动画曲线
    UIViewAnimationOptions animationOptions = curve << 16;
    
    const int extraHeight = 10;
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification])
    {
        
        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
            
            // tool bar
            self.toolBar.frame = CGRectMake(0, self.view.frame.size.height - keyboardHeight - 40, self.view.frame.size.width, 40);
            
            // Editor View
            CGRect editorFrame = self.editorView.frame;
            editorFrame.size.height = (self.view.frame.size.height - keyboardHeight) - 40 - extraHeight;
            self.editorView.frame = editorFrame;
            self.editorView.scrollView.contentInset = UIEdgeInsetsZero;
            self.editorView.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
            
            // Source View
            CGRect sourceFrame = self.sourceView.frame;
            sourceFrame.size.height = (self.view.frame.size.height - keyboardHeight) - 40 - extraHeight;
            self.sourceView.frame = sourceFrame;
            
        } completion:nil];
        
    }
    else
    {
        
        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
            
            // tool bar
            self.toolBar.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40);
            
            // Editor View
            self.editorView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40);
            self.editorView.scrollView.contentInset = UIEdgeInsetsZero;
            self.editorView.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
            
            // Source View
            CGRect sourceFrame = self.sourceView.frame;
            sourceFrame.size.height = ((self.view.frame.size.height - 40) - extraHeight);
            self.sourceView.frame = sourceFrame;
            
            
        } completion:nil];
        
    }
    
}

#pragma mark - LBEditorMessageDelegate
- (void)javaScriptBridgeTextDidChange:(LBEditorMessageHelper *)bridge fieldId:(NSString *)fieldId yOffset:(CGFloat)yOffset height:(CGFloat)height{
    
    self.caretYOffset = @(yOffset);
    self.lineHeight = @(height);
    
    [self refreshVisibleViewportAndContentSize];
    [self scrollToCaretAnimated:NO];
}
- (void)javaScriptBridgeDidFinishLoadingDOM:(LBEditorMessageHelper *)bridge {
    
//    [self.contentField handleDOMLoaded];
}
- (BOOL)javaScriptBridge:(LBEditorMessageHelper *)bridge linkTapped:(NSURL *)url title:(NSString *)title {
    
    return YES;
}
- (BOOL)javaScriptBridge:(LBEditorMessageHelper *)bridge imageTapped:(NSString *)imageId url:(NSURL *)url {
    
    return YES;
}
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge imageTapped:(NSString *)imageId url:(NSURL *)url imageMeta:(WPImageMeta *)imageMeta {
    
}
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge videoTapped:(NSString *)videoID url:(NSURL *)url {
    
}
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge imageReplaced:(NSString *)imageId {
    
}
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge videoReplaced:(NSString *)videoID {
    
}
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge videoStardFullScreen:(NSString *)videoID {
    
//    [self saveSelection];
    // FIXME: SergioEstevao 2015/03/25 - It looks there is a bug on iOS 8 that makes
    // the keyboard not to be hidden when a video is made to run in full screen inside a webview.
    // this workaround searches for the first responder and dismisses it
//    UIView *firstResponder = [self findFirstResponder:self];
//    [firstResponder resignFirstResponder];
}
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge videoEndedFullScreen:(NSString *)videoID {
    
//    [self restoreSelection];
}
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge mediaRemoved:(NSString *)mediaID {
    
}
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge imagePasted:(UIImage *)image {
    
}
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge videoPressInfoRequest:(NSString *)videoPressID {
    
}
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge fieldCreated:(NSString *)fieldId {
    
//    WPEditorField* newField = [self createFieldWithId:fieldId];
}
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge stylesForCurrentSelection:(NSArray*)styles {
    
}
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge selectionChancgeYOffset:(CGFloat)yOffset height:(CGFloat)height {
    
    self.caretYOffset = yOffset == 0 ? nil : @(yOffset);
    self.lineHeight = height == 0 ? nil : @(height);
    [self scrollToCaretAnimated:NO];
}
- (void)javaScriptBridgeTitleDidChange:(LBEditorMessageHelper *)bridge {
    
}
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge fieldFocusedIn:(NSString *)fieldId {
    
}
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge fieldFocusedOut:(NSString *)fieldId {
    
}
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge newField:(NSString *)fieldId {
    
}

#pragma mark - 添加内容时处理滚动
- (void)scrollToCaretAnimated:(BOOL)animated {
    
    BOOL notEnoughInfoToScroll = self.caretYOffset == nil || self.lineHeight == nil;
    
    if (notEnoughInfoToScroll) {
        return;
    }
    
    CGRect viewport = [self viewport];
    CGFloat caretYOffset = [self.caretYOffset floatValue];
    CGFloat lineHeight = [self.lineHeight floatValue];
    CGFloat offsetBottom = caretYOffset + lineHeight;
    
    BOOL mustScroll = (caretYOffset < viewport.origin.y || offsetBottom > viewport.origin.y + CGRectGetHeight(viewport));
    
    if (mustScroll)
    {
        CGFloat necessaryHeight = viewport.size.height / 2;
        
        caretYOffset = MIN(caretYOffset, self.editorView.scrollView.contentSize.height - necessaryHeight);
        
        CGRect targetRect = CGRectMake(0.0f, caretYOffset, CGRectGetWidth(viewport), necessaryHeight);
        
        [self.editorView.scrollView scrollRectToVisible:targetRect animated:animated];
    }
}
- (CGRect)viewport {
    UIScrollView *scrollView = self.editorView.scrollView;
    
    CGRect viewport;
    
    viewport.origin = scrollView.contentOffset;
    viewport.size = scrollView.bounds.size;
    
    viewport.size.height -= (scrollView.contentInset.top + scrollView.contentInset.bottom);
    viewport.size.width -= (scrollView.contentInset.left + scrollView.contentInset.right);
    
    return viewport;
}
// 刷新视窗
- (void)refreshVisibleViewportAndContentSize {
    [self.messageHelper evaluatingJavaScriptFromString:@"ZSSEditor.refreshVisibleViewportSize();"];

#ifdef DEBUG
    [self.messageHelper evaluatingJavaScriptFromString:@"ZSSEditor.logMainElementSizes();"];
#endif

    NSString* newHeightString = [self.editorView stringByEvaluatingJavaScriptFromString:@"$(document.body).height();"];
    NSInteger newHeight = [newHeightString integerValue];

    self.lastEditorHeight = newHeight;
    self.editorView.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), newHeight);
}
@end
