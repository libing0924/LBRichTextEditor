#import "WPEditorFormatbarView.h"

#import <CocoaLumberjack/CocoaLumberjack.h>
#import "WPEditorToolbarButton.h"
#import "ZSSBarButtonItem.h"

@interface WPEditorFormatbarView ()

@property (unsafe_unretained, nonatomic) IBOutlet UIToolbar *leftToolbar;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *horizontalBorder;

// Compact size class bar button items
@property (weak, nonatomic) IBOutlet ZSSBarButtonItem *boldButton;
@property (weak, nonatomic) IBOutlet ZSSBarButtonItem *underLine;
@property (weak, nonatomic) IBOutlet ZSSBarButtonItem *textColor;
@property (weak, nonatomic) IBOutlet ZSSBarButtonItem *backColor;
@property (weak, nonatomic) IBOutlet ZSSBarButtonItem *fontButton;
@property (weak, nonatomic) IBOutlet ZSSBarButtonItem *imageButton;
@property (weak, nonatomic) IBOutlet ZSSBarButtonItem *leftButton;
@property (weak, nonatomic) IBOutlet ZSSBarButtonItem *centerButton;
@property (weak, nonatomic) IBOutlet ZSSBarButtonItem *rightButton;

@end

@implementation WPEditorFormatbarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self baseInit];
    return;
}

- (void)baseInit
{
    self.boldButton.tag = kWPEditorViewControllerElementBold;
    self.underLine.tag = kWPEditorViewControllerElementUnderLine;
    self.textColor.tag = kWPEditorViewControllerElementTextColor;
    self.backColor.tag = kWPEditorViewControllerElementBackColor;
    self.fontButton.tag = kWPEditorViewControllerElementFont;
    self.imageButton.tag = kWPEditorViewControllerElementImage;
    self.leftButton.tag = kWPEditorViewControllerElementAligmentLeft;
    self.centerButton.tag = kWPEditorViewControllerElementAligmentCenter;
    self.rightButton.tag = kWPEditorViewControllerElementAligmentRight;
    [self buildToolbars];
}

#pragma mark - Toolbar building helpers

- (void)buildToolbars
{
    self.leftToolbar.barTintColor = self.backgroundColor;
    self.leftToolbar.translucent = NO;
    self.leftToolbar.clipsToBounds = YES;
    
}

#pragma mark - UITraitEnvironment methods

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    DDLogInfo(@"Format bar trait collection did change from: %@", previousTraitCollection);
}

#pragma mark - Required Delegate Calls
- (IBAction)boldAction:(ZSSBarButtonItem *)sender {
    [self action:sender];
}
- (IBAction)underLineAction:(ZSSBarButtonItem *)sender {
    [self action:sender];
}
- (IBAction)textColorAction:(ZSSBarButtonItem *)sender {
    [self action:sender];
}
- (IBAction)backColorAction:(ZSSBarButtonItem *)sender {
    [self action:sender];
}
- (IBAction)fontAction:(ZSSBarButtonItem *)sender {
    [self action:sender];
}
- (IBAction)imageAction:(ZSSBarButtonItem *)sender {
    [self action:sender];
}
- (IBAction)leftAction:(ZSSBarButtonItem *)sender {
    [self action:sender];
}
- (IBAction)centerAction:(ZSSBarButtonItem *)sender {
    [self action:sender];
}
- (IBAction)rightAction:(ZSSBarButtonItem *)sender {
    [self action:sender];
}

- (void) action:(UIBarButtonItem *) sender {

    WPEditorViewControllerElementTag tag = sender.tag;
    [self.delegate editorToolbarView:self tag:tag];
}

@end
