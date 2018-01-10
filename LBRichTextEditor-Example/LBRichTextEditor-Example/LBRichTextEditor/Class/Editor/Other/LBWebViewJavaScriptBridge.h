//
//  LBWebViewJavaScriptBridge.h
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/9.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const kDefaultURLParameterSeparator = @"~"; // 参数分隔符 这里用~
static NSString* const kDefaultParameterPairSeparator = @"="; // 键值对分隔符

@interface LBWebViewJavaScriptBridge : NSObject

@property (nonatomic, readonly, strong) id webView;

- (instancetype)initWithWebView:(id)webView;


/**
 原生调用JS函数

 @param string JS函数名
 @param handler 处理JS函数的返回结果
 */
- (void)evaluatingJavaScriptFromString:(NSString *)string handler:(void(^)(id result))handler;
- (void)evaluatingJavaScriptFromString:(NSString *)string;

/**
 JS根据函数名调用原生函数

 @param messageName JS函数名
 @param handler 原生函数
 */
- (void)addScriptMessageHandler:(NSString *)messageName handler:(void(^)(id parameter))handler;


/**
 JS根据scheme调用原生函数

 @param schemeName scheme name
 @param handler 原生函数
 */
- (void)addScriptURLSchemeHandler:(NSString *)schemeName handler:(void(^)(NSURL *URL, id parameter))handler;


/**
 判断scheme是否添加到监听列表

 @param schemeName scheme name
 @return YES存在监听列表 NO不存在
 */
- (BOOL)scriptURLSchemeIsExist:(NSString *)schemeName;

@end
