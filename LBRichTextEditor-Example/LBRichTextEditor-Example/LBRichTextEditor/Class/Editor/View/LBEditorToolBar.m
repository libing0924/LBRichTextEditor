//
//  LBEditorToolBar.m
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/8.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import "LBEditorToolBar.h"
#import "LBEditorToolBarButton.h"

@interface LBEditorToolBar()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, copy) void (^callBack)(LBEditorToolBarButtonType);

@end

@implementation LBEditorToolBar

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<LBEditorToolBarButton *> *)items callBack:(void (^ _Nullable)(LBEditorToolBarButtonType))callBack{
    
    if (self = [super initWithFrame:frame])
    {
        
        [self _initializeItems];
        [self addItems:items];
        _callBack = callBack;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame callBack:(void (^ _Nullable)(LBEditorToolBarButtonType))callBack{
    
    if (self = [super initWithFrame:frame])
    {
        [self _initializeItems];
        _callBack = callBack;
    }
    
    return self;
}

- (void) _initializeItems {
    
    _contentView = [[UIScrollView alloc] init];
    _contentView.contentSize = CGSizeZero;
    _contentView.delegate = self;
    [self addSubview:_contentView];
    
}

- (void)addItems:(NSArray<LBEditorToolBarButton *> *)items {
    
    for (LBEditorToolBarButton *button in items)
    {
        if ([button isKindOfClass:LBEditorToolBarButton.class])
        {
            [self addItem:button];
        }
    }
}

- (void)addItem:(LBEditorToolBarButton *)item {
    
    LBEditorToolBarButton *last = self.contentView.subviews.lastObject;
    
    CGFloat X = last ? CGRectGetMaxX(last.frame) + _itemSpace : _itemSpace;
    
    item.frame = CGRectMake(X, CGRectGetMinY(item.frame), CGRectGetWidth(item.frame), CGRectGetHeight(item.frame));
    [item addTarget:self action:@selector(_itemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:item];
}

- (void)setItemSpace:(CGFloat)itemSpace {
    
    if (_itemSpace == itemSpace) return;
    
    _itemSpace = itemSpace;
    
    LBEditorToolBarButton *last = nil;
    CGFloat X = 0;
    for (LBEditorToolBarButton *button in self.contentView.subviews)
    {
        
        X = last ? CGRectGetMaxX(last.frame) + _itemSpace : _itemSpace;
        button.frame = CGRectMake(X, CGRectGetMinY(button.frame), CGRectGetWidth(button.frame), CGRectGetHeight(button.frame));
        
        last = button;
    }
    
}

#pragma MARK - action
- (void)_itemAction:(LBEditorToolBarButton *) sender {
    
    if (self.callBack)
    {
        self.callBack(sender.type);
    }
}

@end
