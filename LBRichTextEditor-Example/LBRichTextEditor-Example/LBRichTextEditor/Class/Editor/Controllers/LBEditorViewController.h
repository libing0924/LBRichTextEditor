//
//  LBEditorViewController.h
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/10.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBEditorToolBar.h"

@interface LBEditorViewController : UIViewController <UIWebViewDelegate, UITextViewDelegate>

- (LBEditorToolBar *)loadToolBar;

@end
