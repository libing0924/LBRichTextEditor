#import <UIKit/UIKit.h>
#import "HRColorPickerViewController.h"

#import "LBEditorToolBar.h"

@class WPEditorField;
@class WPEditorView;
@class WPEditorViewController;
@class WPImageMeta;

typedef enum
{
    kWPEditorViewControllerModePreview = 0,
    kWPEditorViewControllerModeEdit
}
WPEditorViewControllerMode;

@protocol WPEditorViewControllerDelegate <NSObject>
@optional

// 备用
// 暂时未用该协议方法去在子类回调响应事件
- (void)editorDidBeginEditing:(WPEditorViewController *)editorController;
- (void)editorDidEndEditing:(WPEditorViewController *)editorController;
- (void)editorDidFinishLoadingDOM:(WPEditorViewController*)editorController;
- (BOOL)editorShouldDisplaySourceView:(WPEditorViewController *)editorController;
- (void)editorTitleDidChange:(WPEditorViewController *)editorController;
- (void)editorTextDidChange:(WPEditorViewController *)editorController;
- (void)editorDidPressMedia:(WPEditorViewController *)editorController;

- (void)editorFormatBarStatusChanged:(WPEditorViewController *)editorController
                             enabled:(BOOL)isEnabled;
- (void)editorViewController:(WPEditorViewController*)editorViewController
                fieldCreated:(WPEditorField*)field;
- (void)editorViewController:(WPEditorViewController*)editorViewController
       imageTapped:(NSString *)imageId
               url:(NSURL *)url;
- (void)editorViewController:(WPEditorViewController*)editorViewController
                 imageTapped:(NSString *)imageId
                         url:(NSURL *)url
                   imageMeta:(WPImageMeta *)imageMeta;
- (void)editorViewController:(WPEditorViewController*)editorViewController
                 videoTapped:(NSString *)videoID
                         url:(NSURL *)url;
- (void)editorViewController:(WPEditorViewController*)editorViewController
               imageReplaced:(NSString *)imageId;
- (void)editorViewController:(WPEditorViewController*)editorViewController
               videoReplaced:(NSString *)videoID;
- (void)editorViewController:(WPEditorViewController*)editorViewController
               imagePasted:(UIImage *)image;
- (void)editorViewController:(WPEditorViewController *)editorViewController
       videoPressInfoRequest:(NSString *)videoID;
- (void)editorViewController:(WPEditorViewController *)editorViewController
                mediaRemoved:(NSString *)mediaID;

@end

@class ZSSBarButtonItem;

@interface WPEditorViewController : UIViewController

@property (nonatomic, weak) id<WPEditorViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *bodyText;
@property (nonatomic, copy) NSString *bodyPlaceholderText;

@property (nonatomic, strong) UIColor *placeholderColor;

#pragma mark - Editor View
@property (nonatomic, strong, readonly) WPEditorView *editorView;

#pragma mark - Toolbar
@property (nonatomic, strong) LBEditorToolBar *toolbarView;

#pragma mark - Initializers


- (instancetype)initWithMode:(WPEditorViewControllerMode)mode;

#pragma mark - Appearance

- (void)customizeAppearance;

#pragma mark - Editing status

- (BOOL)isEditing;

- (void)startEditing;

- (void)stopEditing;

#pragma mark - Override these in subclasses

- (void)showInsertURLAlternatePicker;

- (void)showInsertImageAlternatePicker;

// 字体点击回调
- (void) setFontSize;

// tool bar的图片按钮点击回调，子类实现
- (void)editorDidPressMedia;

// 图片点击的回调方法，子类实现
- (void)editorViewController:(WPEditorViewController*)editorViewController
                 imageTapped:(NSString *)imageId
                         url:(NSURL *)url
                   imageMeta:(WPImageMeta *)imageMeta;

// html js资源加载完毕，子类实现
- (void)editorDidFinishLoadingDOM;

@end
