//
//  Copyright (c) 2014 Automattic Inc.
//
//  This source file is based on ZSSRichTextEditorViewController.h from ZSSRichTextEditor
//  Created by Nicholas Hubbard on 11/30/13.
//  Copyright (c) 2013 Zed Said Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBEditorViewProtocol.h"
#import "ZSSTextView.h"

@interface WPEditorView : UIView

@property (nonatomic, weak, readwrite) id<WPEditorViewDelegate> delegate;
@property (nonatomic, assign, readonly, getter = isEditing) BOOL editing;

@property (nonatomic, strong, readwrite) ZSSTextView *sourceView;

#pragma mark - Properties: Selection
@property (nonatomic, strong, readonly) NSString *selectedLinkTitle;
@property (nonatomic, strong, readonly) NSString *selectedLinkURL;

#pragma mark - Properties: Fields
@property (nonatomic, strong, readonly) WPEditorField *contentField;
@property (nonatomic, strong, readonly) UIView *sourceContentDividerView;

#pragma mark - Editing
- (void)endEditing;

#pragma mark - 编辑模式
- (BOOL)isInCommonMode; // 是否普通编辑模式
- (void)showHTMLSource; // 显示HTML源码
- (void)showCommonEditor; // 显示普通编辑
- (void)disableEditing;
- (void)enableEditing;


#pragma mark - 获取HTML源码
- (NSString *)contents;

#pragma mark - Styles
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
- (void)setSelectedColor:(UIColor *)color
                     tag:(int)tag;

#pragma mark - Images
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

#pragma mark - Videos
- (void)insertVideo:(NSString *)videoURL posterImage:(NSString *)posterImageURL alt:(NSString *)alt;
- (void)insertInProgressVideoWithID:(NSString *)uniqueId usingPosterImage:(NSString *)posterImageURL;
- (void)setProgress:(double)progress onVideo:(NSString *)uniqueId;
- (void)replaceLocalVideoWithID:(NSString *)uniqueID forRemoteVideo:(NSString *)videoURL remotePoster:(NSString *)posterURL videoPress:(NSString *)videoPressID;
- (void)markVideo:(NSString *)uniqueId failedUploadWithMessage:(NSString *) message;
- (void)unmarkVideoFailedUpload:(NSString *)uniqueId;
- (void)removeVideo:(NSString *)uniqueId;
- (void)setVideoPress:(NSString *)videoPressID source:(NSString *)videoURL poster:(NSString *)posterURL;
- (void)pauseAllVideos;

#pragma mark - Links
- (void)insertLink:(NSString *)url title:(NSString *)title;
- (BOOL)isSelectionALink;
- (void)updateLink:(NSString *)url title:(NSString *)title;
- (void)quickLink;
- (void)removeLink;

#pragma mark - control
- (void)undo;
- (void)redo;
- (void)restoreSelection; // 回复选择的
- (void)saveSelection; // 保存选择的
- (NSString *)selectedText; // 获取选择的文字
- (void)insertHTML:(NSString *)html; // 插入HTML

@end
