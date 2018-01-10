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
@interface LBEditorToolBar : UIView

@property (nonatomic, assign) CGFloat itemSpace;

- (void)addItems:(NSArray<LBEditorToolBarButton *> *) items;
- (void)addItem:(LBEditorToolBarButton *) item;

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<LBEditorToolBarButton *> * _Nullable )items callBack:(void(^ __nullable)(JSMessageType type)) callBack;
- (instancetype)initWithFrame:(CGRect)frame callBack:(void(^ __nullable)(JSMessageType type)) callBack;

@end
NS_ASSUME_NONNULL_END
