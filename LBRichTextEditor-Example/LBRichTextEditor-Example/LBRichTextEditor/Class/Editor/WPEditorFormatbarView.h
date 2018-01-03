#import <UIKit/UIKit.h>

@class WPEditorFormatbarView;
@class ZSSBarButtonItem;

typedef NS_ENUM(NSInteger, WPEditorViewControllerElementTag){

    // lb add
    kWPEditorViewControllerElementBold = 100,
    kWPEditorViewControllerElementUnderLine,
    kWPEditorViewControllerElementTextColor,
    kWPEditorViewControllerElementBackColor,
    kWPEditorViewControllerElementFont,
    kWPEditorViewControllerElementImage,
    kWPEditorViewControllerElementAligmentLeft,
    kWPEditorViewControllerElementAligmentCenter,
    kWPEditorViewControllerElementAligmentRight
};

@protocol WPEditorFormatbarViewDelegate <NSObject>
@required

- (void)editorToolbarView:(WPEditorFormatbarView*)editorToolbarView tag:(WPEditorViewControllerElementTag) tag;

@end


@interface WPEditorFormatbarView : UIView

#pragma mark - Properties: delegate

/**
 *  @brief      The toolbar delegate.
 */
@property (nonatomic, weak, readwrite) id<WPEditorFormatbarViewDelegate> delegate;


@end
