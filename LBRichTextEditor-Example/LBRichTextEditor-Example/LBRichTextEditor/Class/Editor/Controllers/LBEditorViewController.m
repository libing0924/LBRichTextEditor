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

// Tool bar for edit
@property (nonatomic, strong) LBEditorToolBar *toolBar;

// View for display HTML source code
@property (nonatomic, strong) ZSSTextView *sourceView;

// Text editor
@property (nonatomic, strong) UIWebView *editorView;

// Native interaction with JavaScript helper
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
    
    NSArray *items = [self toolBarButtonItems];
    
    if (!items) items = [self _defaultButtonItems];
    
    LBEditorToolBar *toolBar = [[LBEditorToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50) items:items.copy callBack:^(JSMessageType type) {
        
    }];
    
    return toolBar;
}

- (NSArray *)toolBarButtonItems {
    
    return nil;
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

#pragma mark - publick method

- (void)keyboardWillShowOrHide:(NSNotification *)notification {
    
    // Orientation
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // User Info
    NSDictionary *info = notification.userInfo;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    int curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGRect keyboardEnd = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // Keyboard Size
    // Checks if IOS8, gets correct keyboard height
    CGFloat keyboardHeight = UIInterfaceOrientationIsLandscape(orientation) ? ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.000000) ? keyboardEnd.size.height : keyboardEnd.size.width : keyboardEnd.size.height;
    // animation cure
    UIViewAnimationOptions animationOptions = curve << 16;
    
    const int extraHeight = 10;
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification])
    {
        
        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
            
            // tool bar
            self.toolBar.frame = CGRectMake(0, self.view.frame.size.height - keyboardHeight - 50, self.view.frame.size.width, 50);
            
            // Editor View
            CGRect editorFrame = self.editorView.frame;
            editorFrame.size.height = (self.view.frame.size.height - keyboardHeight) - 50 - extraHeight;
            self.editorView.frame = editorFrame;
            self.editorView.scrollView.contentInset = UIEdgeInsetsZero;
            self.editorView.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
            
            // Source View
            CGRect sourceFrame = self.sourceView.frame;
            sourceFrame.size.height = (self.view.frame.size.height - keyboardHeight) - 50 - extraHeight;
            self.sourceView.frame = sourceFrame;
            
        } completion:nil];
        
    }
    else
    {
        
        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
            
            // tool bar
            self.toolBar.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
            
            // Editor View
            self.editorView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50);
            self.editorView.scrollView.contentInset = UIEdgeInsetsZero;
            self.editorView.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
            
            // Source View
            CGRect sourceFrame = self.sourceView.frame;
            sourceFrame.size.height = ((self.view.frame.size.height - 50) - extraHeight);
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

#pragma mark - Call JS Message
- (void)alignLeft {
    
    [self.messageHelper alignLeft];
}
- (void)alignCenter {
    
    [self.messageHelper alignCenter];
}
- (void)alignRight {
    
    [self.messageHelper alignRight];
}
- (void)alignFull {
    
    [self.messageHelper alignFull];
}
- (void)setBold {
    
    [self.messageHelper setBold];
}
- (void)setBlockQuote {
    
    [self.messageHelper setBlockQuote];
}
- (void)setItalic {
    
    [self.messageHelper setItalic];
}
- (void)setSubscript {
    
    [self.messageHelper setSubscript];
}
- (void)setUnderline {
    
    [self.messageHelper setUnderline];
}
- (void)setSuperscript {
    
    [self.messageHelper setSuperscript];
}
- (void)setStrikethrough {
    
    [self.messageHelper setStrikethrough];
}
- (void)setUnorderedList {
    
    [self.messageHelper setUnorderedList];
}
- (void)setOrderedList {
    
    [self.messageHelper setOrderedList];
}
- (void)setHR {
    
    [self.messageHelper setHR];
}
- (void)setIndent {
    
    [self.messageHelper setIndent];
}
- (void)setOutdent {
    
    [self.messageHelper setOutdent];
}
- (void)setParagraph {
    
    [self.messageHelper setParagraph];
}
- (void)removeFormat {
    
    [self.messageHelper removeFormat];
}
- (void)setHeading:(NSString *)head {
    
    [self.messageHelper setHeading:head];
}
- (void)setFontSize:(NSInteger)size {
    
    [self.messageHelper setFontSize:size];
}
- (void)setTextColor:(UIColor *)color {
    
    [self.messageHelper setTextColor:color];
}
- (void)setBackgroundColor:(UIColor *)color {
    
    [self.messageHelper setBackgroundColor:color];
}
- (void)insertHTML:(NSString *)html {
    [self.messageHelper insertHTML:html];
}
- (void)insertLocalImage:(NSString *)url uniqueId:(NSString *)uniqueId {
    
    [self.messageHelper insertLocalImage:url uniqueId:uniqueId];
}
- (void)insertImage:(NSString *)url alt:(NSString *)alt {
    
    [self.messageHelper insertImage:url alt:alt];
}
- (void)replaceLocalImageWithRemoteImage:(NSString *)url uniqueId:(NSString *)uniqueId mediaId:(NSString *)mediaId {
    
    [self.messageHelper replaceLocalImageWithRemoteImage:url uniqueId:uniqueId mediaId:mediaId];
}
- (void)updateImage:(NSString *)url alt:(NSString *)alt {
    
    [self.messageHelper updateImage:url alt:alt];
}
- (void)updateCurrentImageMeta:(WPImageMeta *)imageMeta {
    
    [self.messageHelper updateCurrentImageMeta:imageMeta];
}
- (void)setProgress:(double) progress onImage:(NSString *)uniqueId {
    
    [self.messageHelper setProgress:progress onImage:uniqueId];
}
- (void)markImage:(NSString *)uniqueId failedUploadWithMessage:(NSString *) message {
    
    [self.messageHelper markImage:uniqueId failedUploadWithMessage:message];
}
- (void)unmarkImageFailedUpload:(NSString *)uniqueId {
    
    [self.messageHelper unmarkImageFailedUpload:uniqueId];
}
- (void)removeImage:(NSString *)uniqueId {
    
    [self.messageHelper removeImage:uniqueId];
}
- (void)setImageEditText:(NSString *)text {
    
    [self.messageHelper setImageEditText:text];
}
- (void)insertVideo:(NSString *)videoURL posterImage:(NSString *)posterImageURL alt:(NSString *)alt {
    
    [self.messageHelper insertVideo:videoURL posterImage:posterImageURL alt:alt];
}
- (void)insertInProgressVideoWithID:(NSString *)uniqueId usingPosterImage:(NSString *)posterImageURL {
    
    [self.messageHelper insertInProgressVideoWithID:uniqueId usingPosterImage:posterImageURL];
}
- (void)setProgress:(double)progress onVideo:(NSString *)uniqueId {
    
    [self.messageHelper setProgress:progress onVideo:uniqueId];
}
- (void)replaceLocalVideoWithID:(NSString *)uniqueID forRemoteVideo:(NSString *)videoURL remotePoster:(NSString *)posterURL videoPress:(NSString *)videoPressID {
    
    [self.messageHelper replaceLocalVideoWithID:uniqueID forRemoteVideo:videoURL remotePoster:posterURL videoPress:videoPressID];
}
- (void)markVideo:(NSString *)uniqueId failedUploadWithMessage:(NSString *) message {
    
    [self.messageHelper markVideo:uniqueId failedUploadWithMessage:message];
}
- (void)unmarkVideoFailedUpload:(NSString *)uniqueId {
    
    [self.messageHelper unmarkVideoFailedUpload:uniqueId];
}
- (void)removeVideo:(NSString *)uniqueId {
    
    [self.messageHelper removeVideo:uniqueId];
}
- (void)setVideoPress:(NSString *)videoPressID source:(NSString *)videoURL poster:(NSString *)posterURL {
    
    [self.messageHelper setVideoPress:videoPressID source:videoURL poster:posterURL];
}
- (void)pauseAllVideos {
    
    [self.messageHelper pauseAllVideos];
}
- (void)insertLink:(NSString *)url title:(NSString *)title {
    
    [self.messageHelper insertLink:url title:title];
}
- (void)updateLink:(NSString *)url title:(NSString *)title {
    
    [self.messageHelper updateLink:url title:title];
}
- (void)quickLink {
    
    [self.messageHelper quickLink];
}
- (void)removeLink {
    
    [self.messageHelper removeLink];
}
- (void)undo {
    
    [self.messageHelper undo];
}
- (void)redo {
    
    [self.messageHelper redo];
}
- (void)restoreSelection {
    
    [self.messageHelper restoreSelection];
}
- (void)saveSelection {
    
    [self.messageHelper saveSelection];
}
- (NSString *)getSelectedText {
    
    return [self.messageHelper getSelectedText];
}
- (NSString *)getHTML {
    
    return [self.messageHelper getHTML];
}


#pragma mark - refresh scroll view
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
// Get viewport rect
- (CGRect)viewport {
    
    UIScrollView *scrollView = self.editorView.scrollView;
    
    CGRect viewport;
    
    viewport.origin = scrollView.contentOffset;
    viewport.size = scrollView.bounds.size;
    
    viewport.size.height -= (scrollView.contentInset.top + scrollView.contentInset.bottom);
    viewport.size.width -= (scrollView.contentInset.left + scrollView.contentInset.right);
    
    return viewport;
}
// refresh viewport
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

- (NSArray *)_defaultButtonItems {
    
    NSArray *normalImages = @[@"LBBlod_normal", @"LBItalic_normal", @"LBUnderline_normal", @"LBThroughline_normal", @"LBTextColor_normal", @"LBBGColor_normal", @"LBTextSize_normal", @"LBImage", @"LBVideo"];
    NSArray *types = @[@(JSMessageTypeAttributeBlod), @(JSMessageTypeAttributeItalic), @(JSMessageTypeAttributeUnderline), @(JSMessageTypeAttributeStrikeThrough), @(JSMessageTypeAttributeTextColor), @(JSMessageTypeAttributeBackgroundColor), @(JSMessageTypeAttributeFontSize), @(JSMessageTypeImageInsertLocal), @(JSMessageTypeVideoInsertLocal)];
    
    NSMutableArray *tmpItems = @[].mutableCopy;
    for (int i = 0; i < 9; i++)
    {
        UIImage *normalImage = [UIImage imageNamed:normalImages[i]];
        UIImage *selectedImage = [UIImage imageNamed:@""];
        LBEditorToolBarButton *button = [[LBEditorToolBarButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50) normalImage:normalImage selectedImage:selectedImage type:[types[i] integerValue]];
        [tmpItems addObject:button];
    }
    
    return tmpItems.copy;
}

@end
