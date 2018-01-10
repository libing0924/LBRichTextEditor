//
//  LBWebViewJavaScriptBridge+RichEditor.h
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/9.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import "LBWebViewJavaScriptBridge.h"
#import "WPImageMeta.h"
#import <UIKit/UIKit.h>

@class LBWebViewJavaScriptBridge;
@class WPImageMeta;

@protocol LBBrigeCallbackDelegate <NSObject>
@optional

// 文本改变
- (void)javaScriptBridgeTextDidChange:(LBWebViewJavaScriptBridge *)bridge fieldId:(NSString *)fieldId yOffset:(CGFloat)yOffset height:(CGFloat)height;;
// DOM加载完成
- (void)javaScriptBridgeDidFinishLoadingDOM:(LBWebViewJavaScriptBridge *)bridge;
// 超链接点击
- (BOOL)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge linkTapped:(NSURL *)url title:(NSString *)title;
// 图片点击
- (BOOL)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge imageTapped:(NSString *)imageId url:(NSURL *)url;
// 图片点击
- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge imageTapped:(NSString *)imageId url:(NSURL *)url imageMeta:(WPImageMeta *)imageMeta;
// 视频点击
- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge videoTapped:(NSString *)videoID url:(NSURL *)url;
// 图片替换
- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge imageReplaced:(NSString *)imageId;
// 视频替换
- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge videoReplaced:(NSString *)videoID;
// 视频全屏 JS暂未把id传过来
- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge videoStardFullScreen:(NSString *)videoID;
// 视频退出全屏 JS暂未把id传过来
- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge videoEndedFullScreen:(NSString *)videoID;
// MARK 媒体文件移除 该函数还需要测试
- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge mediaRemoved:(NSString *)mediaID;
// 粘贴图片
- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge imagePasted:(UIImage *)image;
// MARK 功能不明
- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge videoPressInfoRequest:(NSString *)videoPressID;
// 创建field
- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge fieldCreated:(NSString *)fieldId;
// MARK 功能不明
- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge stylesForCurrentSelection:(NSArray*)styles;
- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge selectionChancgeYOffset:(CGFloat)yOffset height:(CGFloat)height;

// 暂未使用
// field id为zss_field_title、zss_field_content其中之一
// 设计之初为了可以编辑HTML的title，后面直接删除了
- (void)javaScriptBridgeTitleDidChange:(LBWebViewJavaScriptBridge *)bridge;
// 改变编辑区域时 当前编辑的field id
- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge fieldFocusedIn:(NSString *)fieldId;
// 改变编辑区域时 退出编辑的field id
- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge fieldFocusedOut:(NSString *)fieldId;
// 创建新的field
- (void)javaScriptBridge:(LBWebViewJavaScriptBridge *)bridge newField:(NSString *)fieldId;

@end

// 基本属性
FOUNDATION_EXPORT NSString * const JSMessageJustifyLeft;
FOUNDATION_EXPORT NSString * const JSMessageJustifyCenter;
FOUNDATION_EXPORT NSString * const JSMessageJustifyRight;
FOUNDATION_EXPORT NSString * const JSMessageJustifyFull;
FOUNDATION_EXPORT NSString * const JSMessageBlod;
FOUNDATION_EXPORT NSString * const JSMessageBlockquote;
FOUNDATION_EXPORT NSString * const JSMessageItalic;
FOUNDATION_EXPORT NSString * const JSMessageSubscript;
FOUNDATION_EXPORT NSString * const JSMessageUnderline;
FOUNDATION_EXPORT NSString * const JSMessageSuperscript;
FOUNDATION_EXPORT NSString * const JSMessageStrikeThrough;
FOUNDATION_EXPORT NSString * const JSMessageUnorderedList;
FOUNDATION_EXPORT NSString * const JSMessageOrderedList;
FOUNDATION_EXPORT NSString * const JSMessageHorizontalRule;
FOUNDATION_EXPORT NSString * const JSMessageIndent;
FOUNDATION_EXPORT NSString * const JSMessageOutdent;
FOUNDATION_EXPORT NSString * const JSMessageFontSize;
FOUNDATION_EXPORT NSString * const JSMessageHeading;
FOUNDATION_EXPORT NSString * const JSMessageParagraph;
FOUNDATION_EXPORT NSString * const JSMessageFormating;
// image
FOUNDATION_EXPORT NSString * const JSMessageInsertLocalImage;
FOUNDATION_EXPORT NSString * const JSMessageInsertRemoteImage;
FOUNDATION_EXPORT NSString * const JSMessageReplaceLocalImageWithRemote;
FOUNDATION_EXPORT NSString * const JSMessageUpdateImage;
FOUNDATION_EXPORT NSString * const JSMessageUpdateImageMeta;
FOUNDATION_EXPORT NSString * const JSMessageSetProgressOnImage;
FOUNDATION_EXPORT NSString * const JSMessageMarkImageUploadFailed;
FOUNDATION_EXPORT NSString * const JSMessageUnmarkImageUploadFailed;
FOUNDATION_EXPORT NSString * const JSMessageRemoveImage;
FOUNDATION_EXPORT NSString * const JSMessageSetImageEditText;
// video
FOUNDATION_EXPORT NSString * const JSMessageInsertVideo;
FOUNDATION_EXPORT NSString * const JSMessageInsertProgressVideoPosterImage;
FOUNDATION_EXPORT NSString * const JSMessageSetProgressOnVideo;
FOUNDATION_EXPORT NSString * const JSMessageReplaceLocalVideoWithRemote;
FOUNDATION_EXPORT NSString * const JSMessageMarkVideoUploadFailed;
FOUNDATION_EXPORT NSString * const JSMessageUnmarkVideoUploadFailed;
FOUNDATION_EXPORT NSString * const JSMessageRemoveVideo;
FOUNDATION_EXPORT NSString * const JSMessageSetVideoPressLinks;
FOUNDATION_EXPORT NSString * const JSMessagePauseAllVideos;
// link
FOUNDATION_EXPORT NSString * const JSMessageInsertLink;
FOUNDATION_EXPORT NSString * const JSMessageUpdateLink;
FOUNDATION_EXPORT NSString * const JSMessageUnlink;
FOUNDATION_EXPORT NSString * const JSMessageQuickLink;

// 用于回调的URL scheme
static NSString * const JSCallbackInputScheme = @"callback-input";
static NSString * const JSCallbackLinkTapScheme = @"callback-link-tap";
static NSString * const JSCallbackImageTapScheme = @"callback-image-tap";
static NSString * const JSCallbackVideoTapScheme = @"callback-video-tap";
static NSString * const JSCallbackLogScheme = @"callback-log";
static NSString * const JSCallbackLogErrorScheme = @"callback-log-error";
static NSString * const JSCallbackNewFieldScheme = @"callback-new-field";
static NSString * const JSCallbackSelectionChangeScheme = @"callback-selection-changed";
static NSString * const JSCallbackSelectionStyleScheme = @"callback-selection-style";
static NSString * const JSCallbackDomLoadedScheme = @"callback-dom-loaded";
static NSString * const JSCallbackImageReplacedScheme = @"callback-image-replaced";
static NSString * const JSCallbackVideoReplacedScheme = @"callback-video-replaced";
static NSString * const JSCallbackVideoFullScreenStartedScheme = @"callback-video-fullscreen-started";
static NSString * const JSCallbackVideoFullScreenEndedScheme = @"callback-video-fullscreen-ended";
static NSString * const JSCallbackVideoPressInfoRequestScheme = @"callback-videopress-info-request";
static NSString * const JSCallbackMediaRemovedScheme = @"callback-media-removed";
static NSString * const JSCallbackPasteScheme = @"callback-paste";
// 暂未使用
static NSString * const JSCallbackFocusInScheme = @"callback-focus-in";
static NSString * const JSCallbackFocusOutScheme = @"callback-focus-out";

@interface LBWebViewJavaScriptBridge (RichEditor)

@property (nonatomic, strong) id<LBBrigeCallbackDelegate> editDelegate;
@property (nonatomic, strong, readwrite) NSString *selectedLinkURL;
@property (nonatomic, strong, readwrite) NSString *selectedLinkTitle;
@property (nonatomic, strong, readwrite) NSString *selectedImageURL;
@property (nonatomic, strong, readwrite) NSString *selectedImageAlt;

+ (instancetype)defaultBrige:(id)webView;

- (void)alignLeft;
- (void)alignCenter;
- (void)alignRight;
- (void)alignFull;
- (void)setBold;
- (void)setBlockQuote;
- (void)setItalic;
- (void)setSubscript;
- (void)setUnderline;
- (void)setSuperscript;
- (void)setStrikethrough;
- (void)setUnorderedList;
- (void)setOrderedList;
- (void)setHR;
- (void)setIndent;
- (void)setOutdent;
- (void)setParagraph;
- (void)removeFormat;
- (void)setHeading:(NSString *) head;
- (void)setFontSize:(NSInteger) size;

- (void)insertLocalImage:(NSString *)url uniqueId:(NSString *)uniqueId;
- (void)insertImage:(NSString *)url alt:(NSString *)alt;
- (void)replaceLocalImageWithRemoteImage:(NSString *)url uniqueId:(NSString *)uniqueId mediaId:(NSString *)mediaId;
- (void)updateImage:(NSString *)url alt:(NSString *)alt;
- (void)updateCurrentImageMeta:(WPImageMeta *)imageMeta;
- (void)setProgress:(double) progress onImage:(NSString *)uniqueId;
- (void)markImage:(NSString *)uniqueId failedUploadWithMessage:(NSString *) message;
- (void)unmarkImageFailedUpload:(NSString *)uniqueId;
- (void)removeImage:(NSString *)uniqueId;
- (void)setImageEditText:(NSString *)text;

- (void)insertVideo:(NSString *)videoURL posterImage:(NSString *)posterImageURL alt:(NSString *)alt;
- (void)insertInProgressVideoWithID:(NSString *)uniqueId usingPosterImage:(NSString *)posterImageURL;
- (void)setProgress:(double)progress onVideo:(NSString *)uniqueId;
- (void)replaceLocalVideoWithID:(NSString *)uniqueID forRemoteVideo:(NSString *)videoURL remotePoster:(NSString *)posterURL videoPress:(NSString *)videoPressID;
- (void)markVideo:(NSString *)uniqueId failedUploadWithMessage:(NSString *) message;
- (void)unmarkVideoFailedUpload:(NSString *)uniqueId;
- (void)removeVideo:(NSString *)uniqueId;
- (void)setVideoPress:(NSString *)videoPressID source:(NSString *)videoURL poster:(NSString *)posterURL;
- (void)pauseAllVideos;

- (void)insertLink:(NSString *)url title:(NSString *)title;
- (BOOL)isSelectionALink;
- (void)updateLink:(NSString *)url title:(NSString *)title;
- (void)quickLink;
- (void)removeLink;

@end
