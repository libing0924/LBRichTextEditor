//
//  LBCommonEditorController.h
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/17.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import "LBEditorViewController.h"

@interface LBCommonEditorController : LBEditorViewController <LBEditorToolBarDelegate>

// Tool bar for edit
@property (nonatomic, strong) LBEditorToolBar *toolBar;

- (NSArray *)loadToolBarButtonItems;

- (void)toolBar:(LBEditorToolBar *)toolBar didClickedButton:(LBEditorToolBarButton *)button type:(JSMessageType)type;

@end
