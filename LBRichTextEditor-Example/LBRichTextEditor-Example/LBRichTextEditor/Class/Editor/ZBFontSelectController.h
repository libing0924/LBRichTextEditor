//
//  ZBFontSelectController.h
//  hhty
//
//  Created by smufs on 2017/8/7.
//  Copyright © 2017年 Yesterday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBFontSelectController : UIViewController

@property (nonatomic, copy) void(^selectFontBlock)(NSInteger tag);

@end
