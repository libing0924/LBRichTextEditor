//
//  LBWenViewJavaScriptBrigeEditorProtocol.h
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/9.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LBEditorToolBarButton.h"

@class LBEditorMessageHelper;
@class WPImageMeta;

@protocol LBEditorMessageDelegate <NSObject>
@optional
// 文本改变
- (void)javaScriptBridgeTextDidChange:(LBEditorMessageHelper *)bridge fieldId:(NSString *)fieldId yOffset:(CGFloat)yOffset height:(CGFloat)height;;
// DOM加载完成
- (void)javaScriptBridgeDidFinishLoadingDOM:(LBEditorMessageHelper *)bridge;
// 超链接点击
- (BOOL)javaScriptBridge:(LBEditorMessageHelper *)bridge linkTapped:(NSURL *)url title:(NSString *)title;
// 图片点击
- (BOOL)javaScriptBridge:(LBEditorMessageHelper *)bridge imageTapped:(NSString *)imageId url:(NSURL *)url;
// 图片点击
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge imageTapped:(NSString *)imageId url:(NSURL *)url imageMeta:(WPImageMeta *)imageMeta;
// 视频点击
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge videoTapped:(NSString *)videoID url:(NSURL *)url;
// 图片替换
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge imageReplaced:(NSString *)imageId;
// 视频替换
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge videoReplaced:(NSString *)videoID;
// 视频全屏 JS暂未把id传过来
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge videoStardFullScreen:(NSString *)videoID;
// 视频退出全屏 JS暂未把id传过来
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge videoEndedFullScreen:(NSString *)videoID;
// MARK 媒体文件移除 该函数还需要测试
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge mediaRemoved:(NSString *)mediaID;
// 粘贴图片
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge imagePasted:(UIImage *)image;
// MARK 功能不明
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge videoPressInfoRequest:(NSString *)videoPressID;
// 创建field
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge fieldCreated:(NSString *)fieldId;
// MARK 功能不明
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge stylesForCurrentSelection:(NSArray*)styles;
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge selectionChancgeYOffset:(CGFloat)yOffset height:(CGFloat)height;

// 暂未使用
// field id为zss_field_title、zss_field_content其中之一
// 设计之初为了可以编辑HTML的title，后面直接删除了
- (void)javaScriptBridgeTitleDidChange:(LBEditorMessageHelper *)bridge;
// 改变编辑区域时 当前编辑的field id
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge fieldFocusedIn:(NSString *)fieldId;
// 改变编辑区域时 退出编辑的field id
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge fieldFocusedOut:(NSString *)fieldId;
// 创建新的field
- (void)javaScriptBridge:(LBEditorMessageHelper *)bridge newField:(NSString *)fieldId;

@end
