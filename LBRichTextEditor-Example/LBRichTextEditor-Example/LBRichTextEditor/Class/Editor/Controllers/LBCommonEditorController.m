//
//  LBCommonEditorController.m
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/17.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import "LBCommonEditorController.h"

@interface LBCommonEditorController ()

@end

@implementation LBCommonEditorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createToolBar];
}

- (void)createToolBar {
    
    self.toolBar = [self loadToolBar];
    
    [self.view addSubview:self.toolBar];
}

- (LBEditorToolBar *)loadToolBar {
    
    NSArray *items = [self toolBarButtonItems];
    
    if (!items) items = [self _defaultButtonItems];
    
    LBEditorToolBar *toolBar = [[LBEditorToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50) items:items.copy delegate:self];
    
    return toolBar;
}

- (void)toolBar:(LBEditorToolBar *)toolBar didClickedButton:(LBEditorToolBarButton *)button type:(JSMessageType)type {
    
    switch (type) {
        case JSMessageTypeAttributeBlod:
        {
            [self setBold];
            break;
        }
        case JSMessageTypeAttributeItalic:
        {
            [self setItalic];
            break;
        }
            case JSMessageTypeAttributeUnderline:
        {
            [self setUnderline];
            break;
        }
            case JSMessageTypeAttributeStrikeThrough:
        {
            [self setStrikethrough];
            break;
        }
            case JSMessageTypeAttributeTextColor:
        {
            [self setTextColor:[UIColor redColor]];
            break;
        }
            case JSMessageTypeAttributeBackgroundColor:
        {
            [self setBackgroundColor:[UIColor blueColor]];
            break;
        }
            case JSMessageTypeAttributeFontSize:
        {
            [self setFontSize:7];
            break;
        }
            case JSMessageTypeVideoInsertLocal:
        {
//            self insertLocalImage:<#(NSString *)#> uniqueId:<#(NSString *)#>
        }
            
        default:
            break;
    }
}

- (NSArray *)toolBarButtonItems { return nil; }


- (NSArray *)_defaultButtonItems {
    
    NSArray *normalImages = @[@"LBBlod_normal", @"LBItalic_normal", @"LBUnderline_normal", @"LBThroughline_normal", @"LBTextColor_normal", @"LBBGColor_normal", @"LBTextSize_normal", @"LBImage", @"LBVideo"];
    NSArray *selectedImages = @[@"LBBlod_selected", @"LBItalic_selected", @"LBUnderline_selected", @"LBThroughline_selected", @"", @"", @"", @"", @""];
    NSArray *types = @[@(JSMessageTypeAttributeBlod), @(JSMessageTypeAttributeItalic), @(JSMessageTypeAttributeUnderline), @(JSMessageTypeAttributeStrikeThrough), @(JSMessageTypeAttributeTextColor), @(JSMessageTypeAttributeBackgroundColor), @(JSMessageTypeAttributeFontSize), @(JSMessageTypeImageInsertLocal), @(JSMessageTypeVideoInsertLocal)];
    
    NSMutableArray *tmpItems = @[].mutableCopy;
    for (int i = 0; i < 9; i++)
    {
        UIImage *normalImage = [UIImage imageNamed:normalImages[i]];
        UIImage *selectedImage = [UIImage imageNamed:selectedImages[i]];
        LBEditorToolBarButton *button = [[LBEditorToolBarButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50) normalImage:normalImage selectedImage:selectedImage type:[types[i] integerValue]];
        [tmpItems addObject:button];
    }
    
    return tmpItems.copy;
}

- (void)keyboardWillShowOrHide:(NSNotification *)notification {
    // Orientation
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // User Info
    NSDictionary *info = notification.userInfo;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    int curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGRect keyboardEnd = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // Keyboard Size
    // Checks if IOS8, gets correct keyboard height
    CGFloat keyboardHeight = UIInterfaceOrientationIsLandscape(orientation) ? ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.000000) ? keyboardEnd.size.height : keyboardEnd.size.width : keyboardEnd.size.height;
    // animation cure
    UIViewAnimationOptions animationOptions = curve << 16;
    
    const int extraHeight = 10;
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        
        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
            
            // tool bar
            self.toolBar.frame = CGRectMake(0, self.view.frame.size.height - keyboardHeight - 50, self.view.frame.size.width, 50);
            
            // Editor View
            CGRect editorFrame = self.editorView.frame;
            editorFrame.size.height = (self.view.frame.size.height - keyboardHeight) - 50 - extraHeight;
            self.editorView.frame = editorFrame;
            self.editorView.scrollView.contentInset = UIEdgeInsetsZero;
            self.editorView.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
            
            // Source View
            CGRect sourceFrame = self.sourceView.frame;
            sourceFrame.size.height = (self.view.frame.size.height - keyboardHeight) - 50 - extraHeight;
            self.sourceView.frame = sourceFrame;
            
        } completion:nil];
        
    } else {
        
        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
            
            // tool bar
            self.toolBar.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
            
            // Editor View
            self.editorView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50);
            self.editorView.scrollView.contentInset = UIEdgeInsetsZero;
            self.editorView.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
            
            // Source View
            CGRect sourceFrame = self.sourceView.frame;
            sourceFrame.size.height = ((self.view.frame.size.height - 50) - extraHeight);
            self.sourceView.frame = sourceFrame;
            
            
        } completion:nil];
        
    }
}

@end
