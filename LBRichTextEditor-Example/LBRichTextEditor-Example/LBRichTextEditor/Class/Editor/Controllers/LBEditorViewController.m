//
//  LBEditorViewController.m
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/10.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import "LBEditorViewController.h"
#import "ZSSTextView.h"
#import "LBWebViewJavaScriptBridge+RichEditor.h"
#import "UIWebView+HackishAccessoryHiding.h"

@interface LBEditorViewController ()

// 编辑工具栏
@property (nonatomic, strong) LBEditorToolBar *toolBar;

// 显示HTML源码的view层
@property (nonatomic, strong) ZSSTextView *sourceView;

// 文本编辑器
@property (nonatomic, strong) UIWebView *editorView;

// native和编辑器JS交互工具
@property (nonatomic, strong) LBWebViewJavaScriptBridge *javaScriptBridge;

@end

@implementation LBEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSourceView];
    
    [self createEditorView];
    
    [self createToolBar];
    
    [self createJavaScriptBridge];
    
    [self loadResource];
}

- (void)createSourceView {
    
    self.sourceView = [[ZSSTextView alloc] initWithFrame:self.view.bounds];
    self.sourceView.hidden = YES;
    self.sourceView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.sourceView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.sourceView.font = [UIFont fontWithName:@"Courier" size:13.0];
    self.sourceView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.sourceView.autoresizesSubviews = YES;
    self.sourceView.delegate = self;
    [self.view addSubview:self.sourceView];
    
}

- (void)createEditorView {
    
    self.editorView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.editorView.delegate = self;
    self.editorView.hidesInputAccessoryView = YES;
    self.editorView.keyboardDisplayRequiresUserAction = NO;
    self.editorView.scalesPageToFit = YES;
    self.editorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.editorView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.editorView.scrollView.bounces = NO;
    self.editorView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.editorView];
    
}

- (void)createToolBar {
    
    self.toolBar = [self toolBar];
    [self.view addSubview:self.toolBar];
}

- (LBEditorToolBar *)toolBar {
    
    __weak typeof(self) weakSelf= self;
    LBEditorToolBar *toolBar = [[LBEditorToolBar alloc] initWithFrame:CGRectZero callBack:^(JSMessageType type) {
        
        // 转发工具栏消息
        [weakSelf.javaScriptBridge handleJSMessage:type];
    }];
    
    return toolBar;
}

- (void)createJavaScriptBridge {
    
    self.javaScriptBridge = [LBWebViewJavaScriptBridge defaultBrige:self.editorView];
}

- (void)loadResource {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *editorURL = [bundle URLForResource:@"editor" withExtension:@"html"];
    [self.editorView loadRequest:[NSURLRequest requestWithURL:editorURL]];
    
}

@end
