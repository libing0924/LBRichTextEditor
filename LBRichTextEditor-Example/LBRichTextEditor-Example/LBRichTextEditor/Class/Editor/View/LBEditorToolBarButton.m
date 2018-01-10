//
//  LBEditorToolBarButton.m
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/8.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import "LBEditorToolBarButton.h"

@implementation LBEditorToolBarButton

+ (instancetype)buttonWithFrame:(CGRect)frame normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage type:(LBEditorToolBarButtonType)type {
    
    return [[LBEditorToolBarButton alloc] initWithFrame:frame normalImage:normalImage selectedImage:selectedImage type:type];
}

- (instancetype)initWithFrame:(CGRect)frame normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage type:(LBEditorToolBarButtonType)type {
    
    if (self = [super initWithFrame:frame])
    {
        [self setImage:normalImage forState:UIControlStateNormal];
        [self setImage:selectedImage forState:UIControlStateSelected];
        _type = type;
    }
    
    return self;
}

@end
