//
//  LBWebViewJavaScriptBridge+RichEditor.h
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/9.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBWebViewJavaScriptBridge.h"
#import "WPImageMeta.h"
#import "LBEditorToolBarButton.h"
#import "LBEditorMessageProtocol.h"

static NSString * const kDefaultURLParameterSeparator = @"~"; // 参数分隔符 这里用~
static NSString * const kDefaultParameterPairSeparator = @"="; // 键值对分隔符

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
FOUNDATION_EXPORT NSString * const JSMessageRemoveFormating;
FOUNDATION_EXPORT NSString * const JSMessageTextColor;
FOUNDATION_EXPORT NSString * const JSMessageBackgroundColor;
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
FOUNDATION_EXPORT NSString * const JSMessageInsertProgressVideoPoster;
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
// control
FOUNDATION_EXPORT NSString * const JSMessageUndo;
FOUNDATION_EXPORT NSString * const JSMessageRedo;
FOUNDATION_EXPORT NSString * const JSMessageRestoreRange;
FOUNDATION_EXPORT NSString * const JSMessageBackupRange;
FOUNDATION_EXPORT NSString * const JSMessageGetSelectedText;
FOUNDATION_EXPORT NSString * const JSMessageInsertHTML;
FOUNDATION_EXPORT NSString * const JSMessageGetHTML;

// 用于回调的URL scheme
static NSString * const JSCallbackSelectionStyleScheme = @"callback-selection-style";
static NSString * const JSCallbackInputScheme = @"callback-input";
static NSString * const JSCallbackLinkTapScheme = @"callback-link-tap";
static NSString * const JSCallbackImageTapScheme = @"callback-image-tap";
static NSString * const JSCallbackVideoTapScheme = @"callback-video-tap";
static NSString * const JSCallbackLogScheme = @"callback-log";
static NSString * const JSCallbackLogErrorScheme = @"callback-log-error";
static NSString * const JSCallbackNewFieldScheme = @"callback-new-field";
static NSString * const JSCallbackSelectionChangeScheme = @"callback-selection-changed";
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

// field id
static NSString * const kWPEditorViewFieldTitleId = @"zss_field_title";
static NSString * const kWPEditorViewFieldContentId = @"zss_field_content";

@interface LBEditorMessageHelper : LBWebViewJavaScriptBridge

@property (nonatomic, strong) id<LBEditorMessageDelegate> editDelegate;
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
- (void)setHeading:(NSString *)head;
- (void)setFontSize:(NSInteger)size;
- (void)setTextColor:(UIColor *)color;
- (void)setBackgroundColor:(UIColor *)color;
- (void)insertHTML:(NSString *) html;

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

- (void)undo;
- (void)redo;
- (void)restoreSelection;
- (void)saveSelection; // 保存选择
- (NSString *)getSelectedText;
- (NSString *)getHTML;

@end
