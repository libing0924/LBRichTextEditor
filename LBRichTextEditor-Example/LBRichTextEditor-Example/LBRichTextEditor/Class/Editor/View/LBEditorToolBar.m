//
//  LBEditorToolBar.m
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/8.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import "LBEditorToolBar.h"
#import "LBEditorToolBarButton.h"

#define DEFAULT_ITEM_SPACE 2.0
#define DEFAULT_BACKGROUND_COLOR [UIColor colorWithRed:241.0 / 255.0f green:241.0 / 255.0f blue:241.0 / 255.0f alpha:1.0]

@interface LBEditorToolBar()<UIScrollViewDelegate>

@property (nonatomic, copy) void (^callBack)(JSMessageType);

@end

@implementation LBEditorToolBar

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<LBEditorToolBarButton *> *)items callBack:(void (^ _Nullable)(JSMessageType))callBack{
    
    if (self = [super initWithFrame:frame])
    {
        _itemSpace = DEFAULT_ITEM_SPACE;
        self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        _callBack = callBack;
        
        [self _initializeItems];
        [self addItems:items];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame callBack:(void (^ _Nullable)(JSMessageType))callBack{
    
    if (self = [super initWithFrame:frame])
    {
        _itemSpace = DEFAULT_ITEM_SPACE;
        self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        _callBack = callBack;
        
        [self _initializeItems];
    }
    
    return self;
}

- (void) _initializeItems {
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    [self addSubview:line];
    
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 1, self.frame.size.width, 50)];
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.contentSize = CGSizeZero;
    _contentView.delegate = self;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
    
    self.contentView.contentSize = CGSizeMake(CGRectGetMaxX(item.frame) + _itemSpace, 0);
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
