#import "WPEditorViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIKit.h>

#import "WPEditorField.h"
#import "WPEditorView.h"
#import "WPImageMeta.h"
#import "ZSSBarButtonItem.h"

@interface WPEditorViewController () <HRColorPickerViewControllerDelegate, WPEditorViewDelegate>

@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, strong) NSArray *editorItemsEnabled;
@property (nonatomic, strong) NSString *selectedImageURL;
@property (nonatomic, strong) NSString *selectedImageAlt;
@property (nonatomic) BOOL didFinishLoadingEditor;
@property (nonatomic, weak) WPEditorField* focusedField;

#pragma mark - Properties: First Setup On View Will Appear
@property (nonatomic, assign, readwrite) BOOL isFirstSetupComplete;

#pragma mark - Properties: Editing
@property (nonatomic, assign, readwrite, getter=isEditingEnabled) BOOL editingEnabled;
@property (nonatomic, assign, readwrite, getter=isEditing) BOOL editing;
@property (nonatomic, assign, readwrite, getter=isEditingTitle) BOOL editingTitle;
@property (nonatomic, assign, readwrite) BOOL wasEditing;

#pragma mark - Properties: Editor View
@property (nonatomic, strong, readwrite) WPEditorView *editorView;

@end

@implementation WPEditorViewController

#pragma mark - Initializers

- (instancetype)init
{
	return [self initWithMode:kWPEditorViewControllerModeEdit];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if (self)
	{
		[self sharedInitializationWithEditing:YES];
	}
	
	return self;
}

- (instancetype)initWithMode:(WPEditorViewControllerMode)mode
{
	self = [super init];
	
	if (self) {
		
		BOOL editing = NO;
		
		if (mode == kWPEditorViewControllerModePreview) {
			editing = NO;
		} else {
			editing = YES;
		}
		
		[self sharedInitializationWithEditing:editing];
	}
	
	return self;
}

#pragma mark - Shared Initialization Code

- (void)sharedInitializationWithEditing:(BOOL)editing
{
	if (editing == kWPEditorViewControllerModePreview) {
		_editing = NO;
	} else {
		_editing = YES;
	}
}

#pragma mark - Creation of subviews

- (void)createToolbarView
{
    
    NSMutableArray *items = [NSMutableArray new];
    NSArray *normalImages = @[@"ZSSbold", @"ZSSunderline", @"ZSStextcolor", @"ZSSbgcolor", @"ZSSfonts", @"ZSSimageDevice", @"ZSSleftjustify", @"ZSScenterjustify", @"ZSSrightjustify"];
    for (int i = 0; i < 9; i++)
    {
        UIImage *normalImage = [UIImage imageNamed:normalImages[i]];
        UIImage *selectedImage = [UIImage imageNamed:@""];
        LBEditorToolBarButton *button = [[LBEditorToolBarButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40) normalImage:normalImage selectedImage:selectedImage type:100 + i];
        [items addObject:button];
    }
    
    
    __weak typeof(self) weakSelf = self;
    _toolbarView = [[LBEditorToolBar alloc] initWithFrame:CGRectZero items:items.copy callBack:^(JSMessageType type) {
        
        __strong typeof(weakSelf) strongeSelf = weakSelf;
        
        if (strongeSelf)
        {
            [strongeSelf _setEditorAttribute:type];
        }
        
    }];
}

- (void) _setEditorAttribute:(JSMessageType)type {
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];	
    self.isFirstSetupComplete = NO;
    self.didFinishLoadingEditor = NO;
    [self createToolbarView];
    [self buildTextViews];
    [self customizeAppearance];
}

- (void)customizeAppearance {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
    if (!self.isFirstSetupComplete) {
        // When restoring state, the navigationController is nil when the view loads,
        // so configure its appearance here instead.
        self.navigationController.navigationBar.translucent = NO;
        
        for (UIView *view in self.navigationController.toolbar.subviews) {
            [view setExclusiveTouch:YES];
        }
        
        if (self.isEditing) {
            [self startEditing];
        }
    }
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isFirstSetupComplete) {
        [self restoreEditSelection];
    } else {
        // Note: Very important this is set here otherwise the post will not initially
        // load properly in the editor. Please be careful if you make a change here and
        // test the editor within WPiOS!
        self.isFirstSetupComplete = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // It's important to save the edit selection before the view disappears, because as soon as it
    // disappears the first responder is changed.
    //
    [self saveEditSelection];
}

- (void)traitCollectionDidChange:(UITraitCollection *) previousTraitCollection
{
    [super traitCollectionDidChange: previousTraitCollection];
    [self recoverFromViewSizeChange];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self recoverFromViewSizeChange];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self.toolbarView setNeedsLayout];
}

#pragma mark - Keyboard shortcuts

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - Toolbar: helper methods

- (UIColor *)placeholderColor {
    if (!_placeholderColor) {
        return [UIColor lightGrayColor];
    }
    return _placeholderColor;
}

#pragma mark - Builders

- (void)buildTextViews
{
    if (!self.editorView) {
        CGFloat viewWidth = CGRectGetWidth(self.view.frame);
        UIViewAutoresizing mask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        CGRect frame = CGRectMake(0.0, 0.0, viewWidth, CGRectGetHeight(self.view.frame));
        
        self.editorView = [[WPEditorView alloc] initWithFrame:frame];
        self.editorView.delegate = self;
        self.editorView.autoresizesSubviews = YES;
        self.editorView.autoresizingMask = mask;
        self.editorView.backgroundColor = [UIColor whiteColor];
        self.editorView.sourceView.inputAccessoryView = self.toolbarView;
        
        // Default placeholder text
        self.bodyPlaceholderText = NSLocalizedString(@"Share your story here...", @"Placeholder for the post body.");
    }
	
    [self.view addSubview:self.editorView];
}

#pragma mark - Getters and Setters

- (NSString*)bodyText
{
    return [self.editorView contents];
}

- (void)setBodyText:(NSString*)bodyText
{
    [self.editorView.contentField setHtml:bodyText];
}

- (void)setBodyPlaceholderText:(NSString*)bodyPlaceholderText
{
    NSParameterAssert(bodyPlaceholderText);
    if (![bodyPlaceholderText isEqualToString:_bodyPlaceholderText]) {
        _bodyPlaceholderText = bodyPlaceholderText;
        [self.editorView.contentField setPlaceholderText:_bodyPlaceholderText];
    }
}

#pragma mark - Actions

#pragma mark - Editor and Misc Methods

- (BOOL)isBodyTextEmpty
{
    if(!self.bodyText
       || self.bodyText.length == 0
       || [[self.bodyText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]
       || [[self.bodyText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"<br>"]
       || [[self.bodyText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"<br />"]) {
        return YES;
    }
    return NO;
}

#pragma mark - Editing

/**
 *	@brief		Enables editing.
 */
- (void)enableEditing
{
	self.editingEnabled = YES;
	
	if (self.didFinishLoadingEditor)
	{
		[self.editorView enableEditing];
	}
}

/**
 *	@brief		Disables editing.
 */
- (void)disableEditing
{
	self.editingEnabled = NO;
	
	if (self.didFinishLoadingEditor)
	{
		[self.editorView disableEditing];
	}
}

/**
 *  @brief      Restored the previously saved edit selection.
 *  @details    Will only really do anything if editing is enabled.
 */
- (void)restoreEditSelection
{
    if (self.isEditing) {
        [self.editorView restoreSelection];
    }
}

/**
 *  @brief      Saves the current edit selection, if any.
 */
- (void)saveEditSelection
{
    if (self.isEditing) {
        [self.editorView saveSelection];
    }
}

- (void)startEditing
{
	self.editing = YES;
	
	// We need the editor ready before executing the steps in the conditional block below.
	// If it's not ready, this method will be called again on webViewDidFinishLoad:
	//
	if (self.didFinishLoadingEditor)
	{
        [self enableEditing];
		[self tellOurDelegateEditingDidBegin];
	}
}

- (void)stopEditing
{
	self.editing = NO;
	
	[self disableEditing];
	[self tellOurDelegateEditingDidEnd];
}

- (void)setBold
{
    [self.editorView setBold];
    
}


- (void)setUnderline
{
	[self.editorView setUnderline];
    
}

- (void)setAligmentLeft {

    [self.editorView alignLeft];
}

- (void)setAligmentCenter {
    
    [self.editorView alignCenter];
}

- (void)setAligmentRight {
    
    [self.editorView alignRight];
}

- (void)textColor
{
    // Save the selection location
	[self.editorView saveSelection];

    // Call the picker
    HRColorPickerViewController *colorPicker = [HRColorPickerViewController cancelableFullColorPickerViewControllerWithColor:[UIColor whiteColor]];
    colorPicker.delegate = self;
    colorPicker.tag = 1;
    colorPicker.title = NSLocalizedString(@"Text Color", nil);
    [self.navigationController pushViewController:colorPicker animated:YES];
}

- (void)bgColor
{
    // Save the selection location
	[self.editorView saveSelection];
    
    // Call the picker
    HRColorPickerViewController *colorPicker = [HRColorPickerViewController cancelableFullColorPickerViewControllerWithColor:[UIColor whiteColor]];
    colorPicker.delegate = self;
    colorPicker.tag = 2;
    colorPicker.title = NSLocalizedString(@"BG Color", nil);
    [self.navigationController pushViewController:colorPicker animated:YES];
}


- (void)insertImage:(NSString *)url alt:(NSString *)alt
{
    [self.editorView insertImage:url alt:alt];
}

- (void)updateImage:(NSString *)url alt:(NSString *)alt
{
    [self.editorView updateImage:url alt:alt];
}

#pragma mark - WPEditorViewDelegate

- (void)editorTextDidChange:(WPEditorView*)editorView
{
	if ([self.delegate respondsToSelector: @selector(editorTextDidChange:)]) {
		[self.delegate editorTextDidChange:self];
	}
}

- (void)editorTitleDidChange:(WPEditorView *)editorView
{
    if ([self.delegate respondsToSelector: @selector(editorTitleDidChange:)]) {
        [self.delegate editorTitleDidChange:self];
    }
}

- (void)editorViewDidFinishLoadingDOM:(WPEditorView*)editorView
{

    self.didFinishLoadingEditor = YES;
    
	if (self.editing) {
		[self startEditing];
	} else {
		[self.editorView disableEditing];
	}
    
    [self tellOurDelegateEditorDidFinishLoadingDOM];
    
    [self editorDidFinishLoadingDOM];
}

- (void)editorView:(WPEditorView*)editorView
      fieldCreated:(WPEditorField*)field
{
    
    if (field == self.editorView.contentField) {
        field.inputAccessoryView = self.toolbarView;
        
        [field setRightToLeftTextEnabled:[self isCurrentLanguageDirectionRTL]];
        [field setMultiline:YES];
        [field setPlaceholderText:self.bodyPlaceholderText];
        [field setPlaceholderColor:self.placeholderColor];
    }
    
    if ([self.delegate respondsToSelector:@selector(editorViewController:fieldCreated:)]) {
        [self.delegate editorViewController:self fieldCreated:field];
    }
}

- (void)editorView:(WPEditorView*)editorView
       imageTapped:(NSString *)imageId
               url:(NSURL *)url
         imageMeta:(WPImageMeta *)imageMeta
{
    if ([self.delegate respondsToSelector:@selector(editorViewController:imageTapped:url:imageMeta:)]) {
        [self.delegate editorViewController:self imageTapped:imageId url:url imageMeta:imageMeta];
    }
    
    [self editorViewController:self imageTapped:imageId url:url imageMeta:imageMeta];
}

- (BOOL)editorView:(WPEditorView*)editorView
       imageTapped:(NSString *)imageId
               url:(NSURL *)url
{
    if ([self.delegate respondsToSelector:@selector(editorViewController:imageTapped:url:)]) {
        [self.delegate editorViewController:self imageTapped:imageId url:url];
    }
    return YES;
}

- (void)editorView:(WPEditorView*)editorView
       videoTapped:(NSString *)videoId
               url:(NSURL *)url
{
    if ([self.delegate respondsToSelector:@selector(editorViewController:videoTapped:url:)]) {
        [self.delegate editorViewController:self videoTapped:videoId url:url];
    }
}

- (void)editorView:(WPEditorView*)editorView
       imageReplaced:(NSString *)imageId
{
    if ([self.delegate respondsToSelector:@selector(editorViewController:imageReplaced:)]) {
        [self.delegate editorViewController:self imageReplaced:imageId];
    }
}

- (void)editorView:(WPEditorView*)editorView
     videoReplaced:(NSString *)videoId
{
    if ([self.delegate respondsToSelector:@selector(editorViewController:videoReplaced:)]) {
        [self.delegate editorViewController:self videoReplaced:videoId];
    }
}

- (void)editorView:(WPEditorView *)editorView videoPressInfoRequest:(NSString *)videoPressID
{
    if ([self.delegate respondsToSelector:@selector(editorViewController:videoPressInfoRequest:)]) {
        [self.delegate editorViewController:self videoPressInfoRequest:videoPressID];
    }

}

- (void)editorView:(WPEditorView *)editorView mediaRemoved:(NSString *)mediaID
{
    if ([self.delegate respondsToSelector:@selector(editorViewController:mediaRemoved:)]) {
        [self.delegate editorViewController:self mediaRemoved:mediaID];
    }
    
}


- (void)editorView:(WPEditorView *)editorView imagePasted:(UIImage *)image
{
    if ([self.delegate respondsToSelector:@selector(editorViewController:imagePasted:)]) {
        [self.delegate editorViewController:self imagePasted:image];
    }
}

- (void)setSelectedColor:(UIColor*)color tag:(int)tag
{
    [self.editorView setSelectedColor:color tag:tag];
}


#ifdef DEBUG
-      (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error
{
//    DDLogError(@"Loading error: %@", error);
	NSAssert(NO,
			 @"This should never happen since the editor is a local HTML page of our own making.");
}
#endif

#pragma mark - Asset Picker

- (void)showInsertURLAlternatePicker
{
    // Blank method. User should implement this in their subclass
	NSAssert(NO, @"Blank method. User should implement this in their subclass");
}

- (void)showInsertImageAlternatePicker
{
    // Blank method. User should implement this in their subclass
	NSAssert(NO, @"Blank method. User should implement this in their subclass");
}

#pragma mark - Utilities

- (void)recoverFromViewSizeChange
{
}

- (BOOL)isCurrentLanguageDirectionRTL
{
    return ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft);
}

#pragma mark - Delegate calls

- (void)tellOurDelegateEditingDidBegin
{
	NSAssert(self.isEditing,
			 @"Can't call this delegate method if not editing.");
	
	if ([self.delegate respondsToSelector: @selector(editorDidBeginEditing:)]) {
		[self.delegate editorDidBeginEditing:self];
	}
}

- (void)tellOurDelegateEditingDidEnd
{
	NSAssert(!self.isEditing,
			 @"Can't call this delegate method if editing.");
	
	if ([self.delegate respondsToSelector: @selector(editorDidEndEditing:)]) {
		[self.delegate editorDidEndEditing:self];
	}
}

- (void)tellOurDelegateEditorDidFinishLoadingDOM
{
    if ([self.delegate respondsToSelector:@selector(editorDidFinishLoadingDOM:)]) {
        [self.delegate editorDidFinishLoadingDOM:self];
    }
}

- (BOOL)askOurDelegateShouldDisplaySourceView
{
    if ([self.delegate respondsToSelector:@selector(editorShouldDisplaySourceView:)]) {
        return [self.delegate editorShouldDisplaySourceView:self];
    }
    return YES;
}

- (void)tellOurDelegateFormatBarStatusHasChanged:(BOOL)isEnabled
{
    if ([self.delegate respondsToSelector:@selector(editorFormatBarStatusChanged:enabled:)]) {
        [self.delegate editorFormatBarStatusChanged:self enabled:isEnabled];
    }
}

- (void) setFontSize{

}

- (void)editorDidPressMedia {

}

- (void)editorViewController:(WPEditorViewController*)editorViewController
                 imageTapped:(NSString *)imageId
                         url:(NSURL *)url
                   imageMeta:(WPImageMeta *)imageMeta{
}

- (void) editorDidFinishLoadingDOM {

}

@end
