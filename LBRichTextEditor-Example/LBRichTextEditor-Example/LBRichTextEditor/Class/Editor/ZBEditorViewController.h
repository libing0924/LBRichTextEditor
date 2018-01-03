//
//  ZBEditorViewController.h
//  hhty
//
//  Created by smufs on 2017/8/6.
//  Copyright © 2017年 Yesterday. All rights reserved.
//

#import "WPEditorViewController.h"

@interface ZBEditorViewController : WPEditorViewController

@property (nonatomic, copy) void(^saveBlock)(NSString *htmlStr);

@property (nonatomic, strong) NSString *htmlStr;

@end
