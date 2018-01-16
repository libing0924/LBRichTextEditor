//
//  LBWebViewJavaScriptBridge.h
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/9.
//  Copyright © 2018年 李冰. All rights reserved.
//
// Using for WKWebView and UIWebView compatibility;
#import <Foundation/Foundation.h>

@interface LBWebViewJavaScriptBridge : NSObject

@property (nonatomic, readonly, strong) id webView;

- (instancetype)initWithWebView:(id)webView;


/**
 Native call JS function

 @param string JS function name
 @param handler Handle result by JS return
 */
- (void)evaluatingJavaScriptFromString:(NSString *)string handler:(void(^)(id result))handler;
- (void)evaluatingJavaScriptFromString:(NSString *)string;

/**
 JS call native with function name

 @param messageName The JS function name which need binded with Native function
 @param handler Native function
 */
- (void)addScriptMessageHandler:(NSString *)messageName handler:(void(^)(id parameter))handler;


/**
 JS call native with scheme name

 @param schemeName The scheme name which need intercepted
 @param handler Native function
 */
- (void)addScriptURLSchemeHandler:(NSString *)schemeName handler:(void(^)(NSURL *URL, id parameter))handler;


/**
 Whether Scheme contained in mapper

 @param schemeName scheme name
 @return YES exist Otherwise not
 */
- (BOOL)scriptURLSchemeIsExist:(NSString *)schemeName;

@end
