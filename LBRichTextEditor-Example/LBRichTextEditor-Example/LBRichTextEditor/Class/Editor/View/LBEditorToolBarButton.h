//
//  LBEditorToolBarButton.h
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/8.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LBEditorToolBarButtonType){
    
    LBEditorToolBarButtonTypeBold = 100, // 粗体
    LBEditorToolBarButtonTypeUnderLine, // 下划线
    LBEditorToolBarButtonTypeTextColor, // 文本颜色
    LBEditorToolBarButtonTypeBackColor, // 背景色
    LBEditorToolBarButtonTypeFont, // 字体大小
    LBEditorToolBarButtonTypeImage, // 图片
    LBEditorToolBarButtonTypeAligmentLeft, // 左对齐
    LBEditorToolBarButtonTypeAligmentCenter, // 居中对齐
    LBEditorToolBarButtonTypeAligmentRight // 右对齐
};

@interface LBEditorToolBarButton : UIButton

@property (nonatomic, readonly, assign) LBEditorToolBarButtonType type;

+ (instancetype)buttonWithFrame:(CGRect)frame normalImage:(UIImage *) normalImage selectedImage:(UIImage *) selectedImage type:(LBEditorToolBarButtonType)type;
- (instancetype)initWithFrame:(CGRect)frame normalImage:(UIImage *) normalImage selectedImage:(UIImage *) selectedImage type:(LBEditorToolBarButtonType)type;

@end
