//
//  LBEditorViewController.m
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/10.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import "LBEditorViewController.h"
#import "UIWebView+HackishAccessoryHiding.h"

@interface LBEditorViewController ()<LBEditorMessageDelegate>

@property (nonatomic, strong, readwrite) NSNumber *caretYOffset;
@property (nonatomic, strong, readwrite) NSNumber *lineHeight;
@property (nonatomic, assign, readwrite) NSInteger lastEditorHeight;

@end

@implementation LBEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create display view with HTML source code
    [self createSourceView];
    
    // create editing view
    [self createEditorView];
    
    // create bridge
    [self createJavaScriptBridge];
    
    // load HTML source
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

- (void)keyboardWillShowOrHide:(NSNotification *)notification { }

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

    NSString *newHeightString = [self.editorView stringByEvaluatingJavaScriptFromString:@"$(document.body).height();"];
    NSInteger newHeight = [newHeightString integerValue];

    self.lastEditorHeight = newHeight;
    self.editorView.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), newHeight);
}

@end
