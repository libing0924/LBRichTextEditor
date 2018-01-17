//
//  LBEditorToolBar.h
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/8.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBEditorToolBarButton.h"

NS_ASSUME_NONNULL_BEGIN
@class LBEditorToolBar, LBEditorToolBarButton;

@protocol LBEditorToolBarDelegate <NSObject>
@optional
- (void) toolBar:(LBEditorToolBar *)toolBar didClickedButton:(LBEditorToolBarButton *)button type:(JSMessageType)type;

@end


@interface LBEditorToolBar : UIView

@property (nonatomic, strong) UIScrollView *contentView;

// default is 10.0
@property (nonatomic, assign) CGFloat itemSpace;

@property (nonatomic, weak) id<LBEditorToolBarDelegate> delegate;

- (void)addItems:(NSArray<LBEditorToolBarButton *> *) items;
- (void)addItem:(LBEditorToolBarButton *) item;

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<LBEditorToolBarButton *> * _Nullable )items delegate:(id<LBEditorToolBarDelegate> _Nullable) delegate;
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<LBEditorToolBarDelegate> _Nullable) delegate;

@end
NS_ASSUME_NONNULL_END
