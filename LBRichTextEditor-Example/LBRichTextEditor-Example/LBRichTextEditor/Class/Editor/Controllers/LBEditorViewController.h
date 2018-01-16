//
//  LBEditorViewController.h
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/10.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBEditorToolBar.h"

@class WPImageMeta;

@interface LBEditorViewController : UIViewController <UIWebViewDelegate, UITextViewDelegate>

- (NSArray *)loadToolBarButtonItems;


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
