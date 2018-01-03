//
//  LBEditorToolView.m
//  LBRichEditorController
//
//  Created by smufs on 2017/8/6.
//  Copyright © 2017年 李冰. All rights reserved.
//

#import "LBEditorToolView.h"
#import "ZSSBarButtonItem.h"

@interface LBEditorToolView ()

/*
 *  Scroll view containing the toolbar
 */
@property (nonatomic, strong) UIScrollView *toolBarScroll;

/*
 *  Toolbar containing ZSSBarButtonItems
 */
@property (nonatomic, strong) UIToolbar *toolbar;

/*
 *  Holder for all of the toolbar components
 */
@property (nonatomic, strong) UIView *toolbarHolder;

@end

@implementation LBEditorToolView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame])
    {
        
        //Scrolling View
        [self createToolBarScroll];
        
        //Toolbar with icons
        [self createToolbar];
        
        //Parent holding view
        [self createParentHoldingView];
        
        [self createBarButton];
    }
    
    return self;
}

- (void)createToolBarScroll {
    
    self.toolBarScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width - 44, 44)];
    self.toolBarScroll.backgroundColor = [UIColor clearColor];
    self.toolBarScroll.showsHorizontalScrollIndicator = NO;
    
}

- (void)createToolbar {
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.toolbar.backgroundColor = [UIColor clearColor];
    [self.toolBarScroll addSubview:self.toolbar];
    self.toolBarScroll.autoresizingMask = self.toolbar.autoresizingMask;
    
}

- (void)createParentHoldingView {
    
    //Background Toolbar
    UIToolbar *backgroundToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    backgroundToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    //Parent holding view
    self.toolbarHolder = [[UIView alloc] init];
    
    
    self.toolbarHolder.frame = CGRectMake(0, self.frame.size.height - 44, self.frame.size.width, 44);

    
    self.toolbarHolder.autoresizingMask = self.toolbar.autoresizingMask;
    [self.toolbarHolder addSubview:self.toolBarScroll];
    [self.toolbarHolder insertSubview:backgroundToolbar atIndex:0];
    
}

- (void) createBarButton {

    NSArray *images = @[@"ZSSbold",@"ZSSfonts",@"ZSStextcolor",@"ZSSbgcolor",@"ZSSimageDevice",@"ZSSleftjustify",@"ZSScenterjustify",@"ZSSrightjustify",@"ZSSforcejustify",@"ZSSunorderedlist",@"ZSSorderedlist",@"ZSSstrikethrough",@"ZSSunderline",@"ZSSlink"];
    
    NSMutableArray *items = [NSMutableArray new];
    for (NSString *imageName in images)
    {
        ZSSBarButtonItem *bold = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:@selector(setBold)];
        [items addObject:bold];
    }
    
    self.toolbar.items = items.copy;
    
}


@end
