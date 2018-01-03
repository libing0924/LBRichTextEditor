//
//  ZBFontSelectController.m
//  hhty
//
//  Created by smufs on 2017/8/7.
//  Copyright © 2017年 Yesterday. All rights reserved.
//

#import "ZBFontSelectController.h"

@interface ZBFontSelectController ()

@end

@implementation ZBFontSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)fontSelectAction:(UIButton *)sender {

    self.selectFontBlock(sender.tag);
}

@end
