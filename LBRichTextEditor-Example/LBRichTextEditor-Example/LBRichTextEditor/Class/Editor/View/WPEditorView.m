//
//  Copyright (c) 2014 Automattic Inc.
//
//  This source file is based on ZSSRichTextEditorViewController.m from ZSSRichTextEditor
//  Created by Nicholas Hubbard on 11/30/13.
//  Copyright (c) 2013 Zed Said Studio. All rights reserved.
//

#import "WPEditorView.h"

#import "UIWebView+GUIFixes.h"
#import "HRColorUtil.h"
#import "WPEditorField.h"
#import "WPImageMeta.h"
#import "ZSSTextView.h"

// 
#import "LBWebViewJavaScriptBridge+RichEditor.h"

static const CGFloat UITextFieldLeftRightInset = 20.0;
static const CGFloat UITextFieldFieldHeight = 55.0;
static const CGFloat SourceTitleTextFieldYOffset = 4.0;
static const CGFloat HTMLViewTopInset = 15.0;
static const CGFloat HTMLViewLeftRightInset = 15.0;

static NSString* const WPEditorViewWebViewContentSizeKey = @"contentSize";

@interface WPEditorView () <UITextViewDelegate, UIWebViewDelegate, UITextFieldDelegate, LBBrigeCallbackDelegate>

@property (nonatomic, strong) LBWebViewJavaScriptBridge *javaScriptBridge;

#pragma mark - Cached caret & line data
@property (nonatomic, strong, readwrite) NSNumber *caretYOffset;
@property (nonatomic, strong, readwrite) NSNumber *lineHeight;

#pragma mark - Editor height
@property (nonatomic, assign, readwrite) NSInteger lastEditorHeight;

#pragma mark - Editing state
@property (nonatomic, assign, readwrite, getter = isEditing) BOOL editing;

#pragma mark - Selection
@property (nonatomic, assign, readwrite) NSRange selectionBackup;

#pragma mark - Subviews
@property (nonatomic, strong, readwrite) UITextField *sourceViewTitleField;
@property (nonatomic, strong, readwrite) ZSSTextView *sourceView;
@property (nonatomic, strong, readonly) UIWebView* webView;

#pragma mark - Editor loading support
@property (nonatomic, copy, readwrite) NSString* preloadedHTML;

@end

@implementation WPEditorView

#pragma mark - NSObject

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.webView.scrollView removeObserver:self forKeyPath:WPEditorViewWebViewContentSizeKey];
}

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if (self) {
		CGRect childFrame = frame;
		childFrame.origin = CGPointZero;
		
        [self createSourceTitleViewWithFrame: childFrame];
        [self createSourceDividerViewWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.sourceViewTitleField.frame), CGRectGetWidth(childFrame), 1.0f)];
        CGRect sourceViewFrame = CGRectMake(0.0f,
                                            CGRectGetMaxY(self.sourceContentDividerView.frame),
                                            CGRectGetWidth(childFrame),
                                            CGRectGetHeight(childFrame)-CGRectGetHeight(self.sourceViewTitleField.frame)-CGRectGetHeight(self.sourceContentDividerView.frame));
        
        [self createSourceViewWithFrame:sourceViewFrame];
		[self createWebViewWithFrame:childFrame];
		[self setupHTMLEditor];
	}
	
	return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
		[[NSNotificationCenter defaultCenter] removeObserver:self];
    } else {
        [self startObservingKeyboardNotifications];
    }
}

#pragma mark - Init helpers

- (void)createSourceTitleViewWithFrame:(CGRect)frame
{
    NSAssert(!_sourceViewTitleField, @"The source view title field must not exist when this method is called!");	

    CGRect titleFrame;
    CGFloat textWidth = CGRectGetWidth(frame) - (2 * UITextFieldLeftRightInset);
    titleFrame = CGRectMake(UITextFieldLeftRightInset, SourceTitleTextFieldYOffset, textWidth, UITextFieldFieldHeight);
    _sourceViewTitleField = [[UITextField alloc] initWithFrame:titleFrame];
    _sourceViewTitleField.hidden = YES;
    _sourceViewTitleField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    _sourceViewTitleField.autocorrectionType = UITextAutocorrectionTypeDefault;
    _sourceViewTitleField.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    _sourceViewTitleField.delegate = self;
    _sourceViewTitleField.accessibilityLabel = NSLocalizedString(@"Title", @"Post title");
    _sourceViewTitleField.returnKeyType = UIReturnKeyNext;
    [self addSubview:_sourceViewTitleField];
}

- (void)createSourceDividerViewWithFrame:(CGRect)frame
{
    NSAssert(!_sourceContentDividerView, @"The source divider view must not exist when this method is called!");
    
    CGFloat lineWidth = CGRectGetWidth(frame) - (2 * UITextFieldLeftRightInset);
    _sourceContentDividerView = [[UIView alloc] initWithFrame:CGRectMake(UITextFieldLeftRightInset, CGRectGetMaxY(frame), lineWidth, CGRectGetHeight(frame))];
    _sourceContentDividerView.backgroundColor = [UIColor lightGrayColor];
    _sourceContentDividerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _sourceContentDividerView.hidden = YES;

    [self addSubview:_sourceContentDividerView];
}

- (void)createSourceViewWithFrame:(CGRect)frame
{
    NSAssert(!_sourceView, @"The source view must not exist when this method is called!");
    
    _sourceView = [[ZSSTextView alloc] initWithFrame:frame];
    _sourceView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _sourceView.autocorrectionType = UITextAutocorrectionTypeNo;
    _sourceView.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _sourceView.autoresizesSubviews = YES;
    _sourceView.textContainerInset = UIEdgeInsetsMake(HTMLViewTopInset, HTMLViewLeftRightInset, 0.0f, HTMLViewLeftRightInset);
    _sourceView.delegate = self;
    [self addSubview:_sourceView];
}

- (void)createWebViewWithFrame:(CGRect)frame
{
	NSAssert(!_webView, @"The web view must not exist when this method is called!");
	
	_webView = [[UIWebView alloc] initWithFrame:frame];
	_webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_webView.delegate = self;
	_webView.scalesPageToFit = YES;
	_webView.dataDetectorTypes = UIDataDetectorTypeNone;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    _webView.scrollView.bounces = NO;
    _webView.usesGUIFixes = YES;
    _webView.keyboardDisplayRequiresUserAction = NO;
    _webView.scrollView.bounces = YES;
    _webView.allowsInlineMediaPlayback = YES;
    [self startObservingWebViewContentSizeChanges];
    
	[self addSubview:_webView];
}

- (void)setupHTMLEditor
{
    NSBundle * bundle = [NSBundle bundleForClass:[WPEditorView class]];
    NSURL * editorURL = [bundle URLForResource:@"editor" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:editorURL]];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    // IMPORTANT: WORKAROUND: the following code is a fix to prevent the web view from thinking it's
    // taller than it really is.  The problem we were having is that when we were switching the
    // focus from the title field to the content field, the web view was trying to scroll down, and
    // jumping back up.
    //
    // The reason behind the sizing issues is that the web view doesn't really like having insets
    // and wants it's body and content to be as tall as possible.
    //
    // Ref bug: https://github.com/wordpress-mobile/WordPress-iOS-Editor/issues/324
    //
    if (object == self.webView.scrollView) {
        
        if ([keyPath isEqualToString:WPEditorViewWebViewContentSizeKey]) {
            NSValue *newValue = change[NSKeyValueChangeNewKey];
            
            CGSize newSize = [newValue CGSizeValue];
        
            if (newSize.height != self.lastEditorHeight) {
                
                // First make sure that the content size is not changed without us recalculating it.
                //
                self.webView.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), self.lastEditorHeight);
                [self workaroundBrokenWebViewRendererBug];
                
                // Then recalculate it asynchronously so the UIWebView doesn't break.
                //
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self refreshVisibleViewportAndContentSize];
                });
            }
        }
	}
}

- (void)startObservingWebViewContentSizeChanges
{
    [_webView.scrollView addObserver:self forKeyPath:WPEditorViewWebViewContentSizeKey options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Bug Workarounds

/**
 *  @brief      Works around a problem caused by another workaround we're using, that's causing the
 *              web renderer to be interrupted before finishing.
 *  @details    When we know of a contentSize change in the web view's scroll view, we override the
 *              operation to manually calculate the proper new size and set it.  This is causing the
 *              web renderer to fail and interrupt.  Drawing doesn't finish properly.  This method
 *              offers a sort of forced redraw mechanism after a very short delay.
 */
- (void)workaroundBrokenWebViewRendererBug
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self redrawWebView];
    });
}

/**
 *  @brief      Redraws the web view, since [webView setNeedsDisplay] doesn't seem to work.
 */
- (void)redrawWebView
{
    NSArray *views = self.webView.scrollView.subviews;
    
    for(int i = 0; i< views.count; i++){
        UIView *view = views[i];
        
        [view setNeedsDisplay];
    }
}

#pragma mark - Keyboard notifications

- (void)startObservingKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - Keyboard status

- (void)keyboardDidShow:(NSNotification *)notification
{
    [self scrollToCaretAnimated:NO];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self refreshKeyboardInsetsWithShowNotification:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    // WORKAROUND: sometimes the input accessory view is not taken into account and a
    // keyboardWillHide: call is triggered instead.  Since there's no way for the source view now
    // to have focus, we'll just make sure the inputAccessoryView is taken into account when
    // hiding the keyboard.
    //
    CGFloat vOffset = self.sourceView.inputAccessoryView.frame.size.height;
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, vOffset, 0.0f);
    
    self.webView.scrollView.contentInset = insets;
    self.webView.scrollView.scrollIndicatorInsets = insets;
    self.sourceView.contentInset = insets;
    self.sourceView.scrollIndicatorInsets = insets;
}


#pragma mark - Keyboard Misc.

/**
 *  @brief      Takes care of calculating and setting the proper insets when the keyboard is shown.
 *  @details    This method can be called from both keyboardWillShow: and keyboardDidShow:.
 *
 *  @param      notification        The notification containing the size info for the keyboard.
 *                                  Cannot be nil.
 */
- (void)refreshKeyboardInsetsWithShowNotification:(NSNotification*)notification
{
    NSParameterAssert([notification isKindOfClass:[NSNotification class]]);
    
    NSDictionary *info = notification.userInfo;
    CGRect keyboardEnd = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect localizedKeyboardEnd = [self convertRect:keyboardEnd fromView:nil];
    CGPoint keyboardOrigin = localizedKeyboardEnd.origin;
    
    if (keyboardOrigin.y > 0) {
        
        CGFloat vOffset = CGRectGetHeight(self.frame) - keyboardOrigin.y;
        
        UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, vOffset, 0.0f);
        
        self.webView.scrollView.contentInset = insets;
        self.webView.scrollView.scrollIndicatorInsets = insets;
        self.sourceView.contentInset = insets;
        self.sourceView.scrollIndicatorInsets = insets;
    }
}

- (void)refreshVisibleViewportAndContentSize
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"ZSSEditor.refreshVisibleViewportSize();"];
    
#ifdef DEBUG
    [self.webView stringByEvaluatingJavaScriptFromString:@"ZSSEditor.logMainElementSizes();"];
#endif
    
    NSString* newHeightString = [self.webView stringByEvaluatingJavaScriptFromString:@"$(document.body).height();"];
    NSInteger newHeight = [newHeightString integerValue];
    
    self.lastEditorHeight = newHeight;
    self.webView.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), newHeight);
}

/**
 *  Finds the first responder in the view hierarchy starting from the currentView
 *
 *  @param currentView the view to start looking for the first responder.
 *
 *  @return the view that is the current first responder nil if none was found.
 */
- (UIView *)findFirstResponder:(UIView *)currentView
{
    if (currentView.isFirstResponder) {
        [currentView resignFirstResponder];
        return currentView;
    }
    for (UIView *subView in currentView.subviews) {
        UIView *result = [self findFirstResponder:subView];
        if (result) {
            return result;
        }
    }
    return nil;
}

#pragma mark - Viewport rect

/**
 *  @brief      Obtain the current viewport.
 *
 *  @returns    The current viewport.
 */
- (CGRect)viewport
{
    UIScrollView* scrollView = self.webView.scrollView;
    
    CGRect viewport;
    
    viewport.origin = scrollView.contentOffset;
    viewport.size = scrollView.bounds.size;
    
    viewport.size.height -= (scrollView.contentInset.top + scrollView.contentInset.bottom);
    viewport.size.width -= (scrollView.contentInset.left + scrollView.contentInset.right);
    
    return viewport;
}

#pragma mark - Fields

/**
 *  @brief      Creates a field for the specified id.
 *  @todo       At some point it would be nice to have WPEditorView be able to handle a custom list
 *              of fields, instead of expecting the HTML page to only have a title and a content
 *              field.
 *
 *  @param      fieldId     The id of the field to create.  This is the id of the html node that
 *                          our new field will wrap.  Cannot be nil.
 *
 *  @returns    The newly created field.
 */
- (WPEditorField*)createFieldWithId:(NSString*)fieldId
{
    NSAssert([fieldId isKindOfClass:[NSString class]],
             @"We're expecting a non-nil NSString object here.");
    
    WPEditorField* newField = nil;
    
    if ([fieldId isEqualToString:kWPEditorViewFieldTitleId]) {
        
    } else if ([fieldId isEqualToString:kWPEditorViewFieldContentId]) {
        NSAssert(!_contentField,
                 @"We should never have to set this twice.");
        
        _contentField = [[WPEditorField alloc] initWithId:fieldId webView:self.webView];
        newField = self.contentField;
    }
    NSAssert([newField isKindOfClass:[WPEditorField class]],
             @"A new field should've been created here.");
    
    return newField;
}

#pragma mark - URL & HTML utilities

/**
 *  @brief      Adds slashes to the specified HTML string, to prevent injections when calling JS
 *              code.
 *
 *  @param      html        The HTML string to add slashes to.  Cannot be nil.
 *
 *  @returns    The HTML string with the added slashes.
 */
- (NSString *)addSlashes:(NSString *)html
{
    html = [html stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    html = [html stringByReplacingOccurrencesOfString:@"\r"  withString:@"\\r"];
    html = [html stringByReplacingOccurrencesOfString:@"\n"  withString:@"\\n"];
    
    return html;
}

- (NSString *)stringByDecodingURLFormat:(NSString *)string
{
    NSString *result = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByRemovingPercentEncoding];
    return result;
}

#pragma mark - Interaction

- (void)undo
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"ZSSEditor.undo();"];
}

- (void)redo
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"ZSSEditor.redo();"];
}

#pragma mark - Text Access

- (NSString*)contents
{
    NSString* contents = nil;
    
    if ([self isInCommonMode]) {
        contents = [self.contentField html];
    } else {
        contents =  self.sourceView.text;
    }
    
    return contents;
}

- (NSString*)title
{
    NSString* title = nil;
    
    if ([self isInCommonMode]) {
        title = [self.titleField strippedHtml];
    } else {
        title =  self.sourceViewTitleField.text;
    }
    
    return title;
}

#pragma mark - Scrolling support

/**
 *  @brief      Scrolls to a position where the caret is visible. This uses the values stored in caretYOffest and lineHeight properties.
 *  @param      animated    If the scrolling shoud be animated  The offset to show.
 */
- (void)scrollToCaretAnimated:(BOOL)animated
{
    BOOL notEnoughInfoToScroll = self.caretYOffset == nil || self.lineHeight == nil;
    
    if (notEnoughInfoToScroll) {
        return;
    }
    
    CGRect viewport = [self viewport];
    CGFloat caretYOffset = [self.caretYOffset floatValue];
    CGFloat lineHeight = [self.lineHeight floatValue];
    CGFloat offsetBottom = caretYOffset + lineHeight;
    
    BOOL mustScroll = (caretYOffset < viewport.origin.y
                       || offsetBottom > viewport.origin.y + CGRectGetHeight(viewport));
    
    if (mustScroll) {
        // DRM: by reducing the necessary height we avoid an issue that moves the caret out
        // of view.
        //
        CGFloat necessaryHeight = viewport.size.height / 2;
        
        // DRM: just make sure we don't go out of bounds with the desired yOffset.
        //
        caretYOffset = MIN(caretYOffset,
                           self.webView.scrollView.contentSize.height - necessaryHeight);
        
        CGRect targetRect = CGRectMake(0.0f,
                                       caretYOffset,
                                       CGRectGetWidth(viewport),
                                       necessaryHeight);
        
        [self.webView.scrollView scrollRectToVisible:targetRect animated:animated];
    }
}

#pragma mark - Selection

- (void)restoreSelection
{
    if (self.isInCommonMode) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"ZSSEditor.restoreRange();"];
    } else {
        [self.sourceView select:self];
        [self.sourceView setSelectedRange:self.selectionBackup];
        self.selectionBackup = NSMakeRange(0, 0);
    }
    
}

- (void)saveSelection
{
    if (self.isInCommonMode) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"ZSSEditor.backupRange();"];
    } else {
        self.selectionBackup = self.sourceView.selectedRange;
    }
}

- (NSString*)selectedText
{
    NSString* selectedText;
    if (self.isInCommonMode) {
        selectedText = [self.webView stringByEvaluatingJavaScriptFromString:@"ZSSEditor.getSelectedText();"];
    } else {
        NSRange range = [self.sourceView selectedRange];
        selectedText = [self.sourceView.text substringWithRange:range];
    }
    
	return selectedText;
}

- (void)setSelectedColor:(UIColor*)color tag:(int)tag
{
    NSString *hex = [NSString stringWithFormat:@"#%06x",HexColorFromUIColor(color)];
    NSString *trigger;
    if (tag == 1) {
        trigger = [NSString stringWithFormat:@"ZSSEditor.setTextColor(\"%@\");", hex];
    } else if (tag == 2) {
        trigger = [NSString stringWithFormat:@"ZSSEditor.setBackgroundColor(\"%@\");", hex];
    }
	
	[self.webView stringByEvaluatingJavaScriptFromString:trigger];
	
}

#pragma mark - URL normalization
- (NSString*)normalizeURL:(NSString*)url
{
    static NSString* const kDefaultScheme = @"http://";
    static NSString* const kURLSchemePrefix = @"://";
    
    NSString* normalizedURL = url;
    NSRange substringRange = [url rangeOfString:kURLSchemePrefix];

    if (substringRange.length == 0) {
        normalizedURL = [kDefaultScheme stringByAppendingString:url];
    }
    
    return normalizedURL;
}

#pragma mark - Editor: HTML interaction

// Inserts HTML at the caret position
- (void)insertHTML:(NSString *)html
{
    NSString *cleanedHTML = [self addSlashes:html];
    NSString *trigger = [NSString stringWithFormat:@"ZSSEditor.insertHTML(\"%@\");", cleanedHTML];
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
}

#pragma mark - Editing

- (void)wrapSourceViewSelectionWithTag:(NSString *)tag
{
    NSParameterAssert([tag isKindOfClass:[NSString class]]);
    NSRange range = self.sourceView.selectedRange;
    NSString *selection = [self.sourceView.text substringWithRange:range];
    NSString *prefix, *suffix;
    if ([tag isEqualToString:@"more"]) {
        prefix = @"<!--more-->";
        suffix = @"\n";
    } else if ([tag isEqualToString:@"blockquote"]) {
        prefix = [NSString stringWithFormat:@"\n<%@>", tag];
        suffix = [NSString stringWithFormat:@"</%@>\n", tag];
    } else {
        prefix = [NSString stringWithFormat:@"<%@>", tag];
        suffix = [NSString stringWithFormat:@"</%@>", tag];
    }
    
    NSString *replacement = [NSString stringWithFormat:@"%@%@%@",prefix,selection,suffix];
    [self.sourceView insertText:replacement];
}

- (void)endEditing;
{
	[self.webView endEditing:YES];
	[self.sourceView endEditing:YES];
}

#pragma mark - Editor mode

- (BOOL)isInCommonMode
{
	return !self.webView.hidden;
}

- (void)showHTMLSource
{
	self.sourceView.text = [self.contentField html];
	self.sourceView.hidden = NO;
    self.sourceViewTitleField.hidden = NO;
    self.sourceContentDividerView.hidden = NO;
	self.webView.hidden = YES;
    
    [self.sourceView becomeFirstResponder];
    
    UITextPosition* position = [self.sourceView positionFromPosition:[self.sourceView beginningOfDocument]
                                                              offset:0];
    
    [self.sourceView setSelectedTextRange:[self.sourceView textRangeFromPosition:position toPosition:position]];
}

- (void)showCommonEditor
{
    BOOL titleHadFocus = self.sourceViewTitleField.isFirstResponder;
    
	[self.contentField setHtml:self.sourceView.text];
	self.sourceView.hidden = YES;
    self.sourceViewTitleField.hidden = YES;
    self.sourceContentDividerView.hidden = YES;
	self.webView.hidden = NO;
    
    if (titleHadFocus)
    {
    }
    else
    {
        [self.contentField focus];
    }
}

#pragma mark - Editing lock
- (void)disableEditing
{
    if (!self.sourceView.hidden) {
        [self showCommonEditor];
    }
    
    [self.contentField disableEditing];
    [self.sourceViewTitleField setEnabled:NO];
    [self.sourceView setEditable:NO];
}

- (void)enableEditing
{
    [self.contentField enableEditing];
    [self.sourceViewTitleField setEnabled:YES];
    [self.sourceView setEditable:YES];
}

#pragma mark - 调用JS函数
- (void)alignLeft {
    [self.javaScriptBridge alignLeft];
}
- (void)alignCenter {
    [self.javaScriptBridge alignCenter];
}
- (void)alignRight {
    [self.javaScriptBridge alignRight];
}
- (void)alignFull {
    [self.javaScriptBridge alignFull];
}
- (void)setBold {
    [self.javaScriptBridge setBold];
}
- (void)setBlockQuote {
    [self.javaScriptBridge setBlockQuote];
}
- (void)setItalic {
    [self.javaScriptBridge setItalic];
}
- (void)setSubscript {
    [self.javaScriptBridge setSubscript];
}
- (void)setUnderline {
    [self.javaScriptBridge setUnderline];
}
- (void)setSuperscript {
    [self.javaScriptBridge setSuperscript];
}
- (void)setStrikethrough {
    [self.javaScriptBridge setStrikethrough];
}
- (void)setUnorderedList {
    [self.javaScriptBridge setUnorderedList];
}
- (void)setOrderedList {
    [self.javaScriptBridge setOrderedList];
}
- (void)setHR {
    [self.javaScriptBridge setHR];
}
- (void)setIndent {
    [self.javaScriptBridge setIndent];
}
- (void)setOutdent {
    [self.javaScriptBridge setOutdent];
}
- (void)setParagraph {
    [self.javaScriptBridge setParagraph];
}
- (void)removeFormat {
    [self.javaScriptBridge removeFormat];
}
- (void)setHeading:(NSString *) head {
    [self.javaScriptBridge setHeading:head];
}
- (void)setFontSize:(NSInteger) size {
    [self.javaScriptBridge setFontSize:size];
}
- (void)insertLocalImage:(NSString *)url uniqueId:(NSString *)uniqueId {
    [self.javaScriptBridge insertLocalImage:url uniqueId:uniqueId];
}
- (void)insertImage:(NSString *)url alt:(NSString *)alt {
    [self.javaScriptBridge insertImage:url alt:alt];
}
- (void)replaceLocalImageWithRemoteImage:(NSString*)url uniqueId:(NSString*)uniqueId mediaId:(NSString *)mediaId {
    [self.javaScriptBridge replaceLocalImageWithRemoteImage:url uniqueId:uniqueId mediaId:mediaId];
}
- (void)updateImage:(NSString *)url alt:(NSString *)alt {
    [self.javaScriptBridge updateImage:url alt:alt];
}
- (void)updateCurrentImageMeta:(WPImageMeta *)imageMeta {
    [self.javaScriptBridge updateCurrentImageMeta:imageMeta];
}
- (void)setProgress:(double) progress onImage:(NSString*)uniqueId {
    [self.javaScriptBridge setProgress:progress onImage:uniqueId];
}
- (void)markImage:(NSString *)uniqueId failedUploadWithMessage:(NSString*) message {
    [self.javaScriptBridge markImage:uniqueId failedUploadWithMessage:message];
}
- (void)unmarkImageFailedUpload:(NSString *)uniqueId {
    [self.javaScriptBridge unmarkImageFailedUpload:uniqueId];
}
- (void)removeImage:(NSString*)uniqueId {
    [self.javaScriptBridge removeImage:uniqueId];
}
- (void)setImageEditText:(NSString *)text {
    [self.javaScriptBridge setImageEditText:text];
}
- (void)insertVideo:(NSString *)videoURL posterImage:(NSString *)posterImageURL alt:(NSString *)alt {
    [self.javaScriptBridge insertVideo:videoURL posterImage:posterImageURL alt:alt];
}
- (void)insertInProgressVideoWithID:(NSString *)uniqueId usingPosterImage:(NSString *)posterImageURL {
    [self.javaScriptBridge insertInProgressVideoWithID:uniqueId usingPosterImage:posterImageURL];
}
- (void)setProgress:(double)progress onVideo:(NSString *)uniqueId {
    [self.javaScriptBridge setProgress:progress onVideo:uniqueId];
}
- (void)replaceLocalVideoWithID:(NSString *)uniqueID forRemoteVideo:(NSString *)videoURL remotePoster:(NSString *)posterURL videoPress:(NSString *)videoPressID {
    [self.javaScriptBridge replaceLocalVideoWithID:uniqueID forRemoteVideo:videoURL remotePoster:posterURL videoPress:videoPressID];
}
- (void)markVideo:(NSString *)uniqueId failedUploadWithMessage:(NSString*) message; {
    [self.javaScriptBridge markVideo:uniqueId failedUploadWithMessage:message];
}
- (void)unmarkVideoFailedUpload:(NSString *)uniqueId {
    [self.javaScriptBridge unmarkVideoFailedUpload:uniqueId];
}
- (void)removeVideo:(NSString*)uniqueId {
    [self.javaScriptBridge removeVideo:uniqueId];
}
- (void)setVideoPress:(NSString *)videoPressID source:(NSString *)videoURL poster:(NSString *)posterURL {
    [self.javaScriptBridge setVideoPress:videoPressID source:videoURL poster:posterURL];
}
- (void)pauseAllVideos {
    [self.javaScriptBridge pauseAllVideos];
}
- (void)insertLink:(NSString *)url title:(NSString*)title {
    [self.javaScriptBridge insertLink:url title:title];
}
- (BOOL)isSelectionALink {
    return self.selectedLinkURL != nil;
}
- (void)updateLink:(NSString *)url title:(NSString*)title {
    [self.javaScriptBridge updateLink:url title:title];
}
- (void)removeLink {
    [self.javaScriptBridge removeLink];
}
- (void)quickLink {
    [self quickLink];
}

#pragma mark - JS的回调
- (void)javaScriptBridgeTextDidChange:(LBWebViewJavaScriptBridge *)bridge fieldId:(NSString *)fieldId yOffset:(CGFloat)yOffset height:(CGFloat)height{

    self.caretYOffset = @(yOffset);
    self.lineHeight = @(height);
    
    // WORKAROUND: it seems that without this call, typing doesn't always follow the caret
    // position.
    //
    // HOW TO TEST THIS: disable the following line, and run the demo... type in the contents
    // field while also showing the virtual keyboard.  You'll notice the caret can, at times,
    // go behind the virtual keyboard.
    //
    [self refreshVisibleViewportAndContentSize];
    [self scrollToCaretAnimated:NO];
}

- (void)javaScriptBridgeDidFinishLoadingDOM:(LBWebViewJavaScriptBridge *)bridge {
    
    [self.contentField handleDOMLoaded];
}

- (BOOL)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge linkTapped:(NSURL *)url title:(NSString *)title {
    
}

- (BOOL)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge imageTapped:(NSString *)imageId url:(NSURL *)url {
    
}

- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge imageTapped:(NSString *)imageId url:(NSURL *)url imageMeta:(WPImageMeta *)imageMeta {
    
}

- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge videoTapped:(NSString *)videoID url:(NSURL *)url {
    
}

- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge imageReplaced:(NSString *)imageId {
    
}

- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge videoReplaced:(NSString *)videoID {
    
}

- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge videoStardFullScreen:(NSString *)videoID {
    
    [self saveSelection];
    // FIXME: SergioEstevao 2015/03/25 - It looks there is a bug on iOS 8 that makes
    // the keyboard not to be hidden when a video is made to run in full screen inside a webview.
    // this workaround searches for the first responder and dismisses it
    UIView *firstResponder = [self findFirstResponder:self];
    [firstResponder resignFirstResponder];
}

- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge videoEndedFullScreen:(NSString *)videoID {
    
    [self restoreSelection];
}

- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge mediaRemoved:(NSString *)mediaID {
    
}

- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge imagePasted:(UIImage *)image {
    
}

- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge videoPressInfoRequest:(NSString *)videoPressID {
    
}

- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge fieldCreated:(NSString *)fieldId {
    
    WPEditorField* newField = [self createFieldWithId:fieldId];
}

- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge stylesForCurrentSelection:(NSArray*)styles {
    
}
- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge selectionChancgeYOffset:(CGFloat)yOffset height:(CGFloat)height {
    
    self.caretYOffset = @(yOffset);
    self.lineHeight = @(height);
    [self scrollToCaretAnimated:NO];
}

- (void)javaScriptBridgeTitleDidChange:(LBWebViewJavaScriptBridge *)bridge {
    
}

- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge fieldFocusedIn:(NSString *)fieldId {
    
}

- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge fieldFocusedOut:(NSString *)fieldId {
    
}

- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge newField:(NSString *)fieldId {
    
}

@end
