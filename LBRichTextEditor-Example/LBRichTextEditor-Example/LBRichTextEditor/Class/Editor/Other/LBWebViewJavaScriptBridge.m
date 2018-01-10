//
//  LBWebViewJavaScriptBridge.m
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/9.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import "LBWebViewJavaScriptBridge.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface LBWebViewJavaScriptBridge ()<UIWebViewDelegate, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) NSMutableDictionary *schemeMapper;

@end

@implementation LBWebViewJavaScriptBridge

- (instancetype)initWithWebView:(id)webView {
    
    if (self = [super init])
    {
        
        if (![webView isKindOfClass:[UIWebView class]] && ![webView isKindOfClass:[WKWebView class]])
        {
            @throw [NSException exceptionWithName:@"异常错误" reason:@"webView 不合法" userInfo:nil];
        }
        
        _webView = webView;
        
        if ([_webView isKindOfClass:[UIWebView class]])
        {
            UIWebView *webView = (UIWebView *)_webView;
            
            webView.delegate = self;
        }
        else
        {
            WKWebView *webView = (WKWebView *)_webView;
            
            webView.UIDelegate = self;
            
            webView.navigationDelegate = self;
        }
        
        // 重写webView代理的回调处理相关URL事件，这个版本暂不实现，直接把webView的代理设置为自己
    }
    
    return self;
}

- (void)evaluatingJavaScriptFromString:(NSString *)string handler:(void (^)(id))handler {
    
    [self _evaluatingJavaScriptFromString:string handler:handler];
}

- (void)evaluatingJavaScriptFromString:(NSString *)string {
    [self evaluatingJavaScriptFromString:string handler:nil];
}

- (void)addScriptMessageHandler:(NSString *)messageName handler:(void (^)(id))handler {
    
}

- (void)addScriptURLSchemeHandler:(NSString *)schemeName handler:(void (^)(NSURL *URL, id parameter))handler {
    
    [self.schemeMapper setObject:handler forKey:schemeName];
}

- (BOOL)scriptURLSchemeIsExist:(NSString *)schemeName {
    
    id handler = [self.schemeMapper objectForKey:schemeName];
    
    return handler ? YES : NO;
}

- (void) _evaluatingJavaScriptFromString:(NSString *) string handler:(void(^)(id result)) handler {
    
    if ([_webView isKindOfClass:[UIWebView class]])
    {
        JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        
        JSValue *resultValue = [context evaluateScript:string];
        
        if (handler) handler(resultValue);
    }
    else
    {
        WKWebView *webView = (WKWebView *)_webView;
        
        [webView evaluateJavaScript:string completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            
        }];
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *scheme = request.URL.scheme;
    
    if ([self scriptURLSchemeIsExist:scheme])
    {
        // 解析URL
        NSDictionary *parameter = [self _parseParametersWithURL:request.URL];
        
        void(^handler)(NSURL *URL, id parameter) = [self.schemeMapper objectForKey:scheme];
        
        // 回调原生函数
        handler(request.URL, parameter);
        
        return NO;
    }
    
    return YES;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *scheme = navigationAction.request.URL.scheme;
    
    if ([self scriptURLSchemeIsExist:scheme])
    {
        // 解析URL
        NSDictionary *parameter = [self _parseParametersWithURL:navigationAction.request.URL];
        
        void(^handler)(NSURL *URL, id parameter) = [self.schemeMapper objectForKey:scheme];
        
        // 回调原生函数
        handler(scheme, parameter);
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 解析URL的query参数集
- (NSDictionary *)_parseParametersWithURL:(NSURL *)url {
    
    NSParameterAssert([url isKindOfClass:[NSURL class]]);
    
    NSString *query = url.query;
    
    NSArray *keyValuePairs = [query componentsSeparatedByString:kDefaultURLParameterSeparator];
    
    if (keyValuePairs.count == 0 || !keyValuePairs) return nil;
    
    NSMutableDictionary *tmp = @{}.mutableCopy;
    
    for (NSString *keyValuePair in keyValuePairs)
    {
        if ([keyValuePair isKindOfClass:[NSString class]])
        {
            NSArray *keyValue = [keyValuePair componentsSeparatedByString:kDefaultParameterPairSeparator];
            
            if (keyValue.count == 2)
            {
                [tmp setObject:keyValue.lastObject forKey:keyValue.firstObject];
                continue;
            }
        }
    }
    
    return tmp.copy;
}

- (NSMutableDictionary *)schemeMapper {
    
    if (_schemeMapper) return _schemeMapper;
    
    _schemeMapper =@{}.mutableCopy;
    
    return _schemeMapper;
}

@end
