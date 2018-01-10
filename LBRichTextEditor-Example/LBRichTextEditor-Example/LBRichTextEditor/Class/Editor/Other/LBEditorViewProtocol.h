
//
//  LBEditorViewDelegate.h
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/9.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPEditorView;
@class WPEditorField;
@class WPImageMeta;

@protocol WPEditorViewDelegate <UIWebViewDelegate>
@optional

- (void)editorTextDidChange:(WPEditorView *)editorView;
- (void)editorTitleDidChange:(WPEditorView *)editorView;
- (void)editorViewDidFinishLoadingDOM:(WPEditorView *)editorView;
- (void)editorViewDidFinishLoading:(WPEditorView *)editorView;
- (void)editorView:(WPEditorView *)editorView fieldCreated:(WPEditorField *)field;
- (void)editorView:(WPEditorView *)editorView fieldFocused:(WPEditorField *)field;
- (void)editorView:(WPEditorView *)editorView sourceFieldFocused:(UIView *)view;
- (BOOL)editorView:(WPEditorView *)editorView linkTapped:(NSURL *)url title:(NSString *)title;
- (BOOL)editorView:(WPEditorView *)editorView imageTapped:(NSString *)imageId url:(NSURL *)url;
- (void)editorView:(WPEditorView *)editorView imageTapped:(NSString *)imageId url:(NSURL *)url imageMeta:(WPImageMeta *)imageMeta;
- (void)editorView:(WPEditorView *)editorView videoTapped:(NSString *)videoID url:(NSURL *)url;
- (void)editorView:(WPEditorView *)editorView stylesForCurrentSelection:(NSArray*)styles;
- (void)editorView:(WPEditorView *)editorView imageReplaced:(NSString *)imageId;
- (void)editorView:(WPEditorView*)editorView videoReplaced:(NSString *)videoID;
- (void)editorView:(WPEditorView*)editorView imagePasted:(UIImage *)image;
- (void)editorView:(WPEditorView *)editorView videoPressInfoRequest:(NSString *)videoPressID;
- (void)editorView:(WPEditorView *)editorView mediaRemoved:(NSString *)mediaID;

@end
