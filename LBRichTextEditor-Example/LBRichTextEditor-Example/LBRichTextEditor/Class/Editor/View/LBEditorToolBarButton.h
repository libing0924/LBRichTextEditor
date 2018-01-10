//
//  LBEditorToolBarButton.h
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/8.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JSMessageType) {
    
    JSMessageTypeAttributeJustifyLeft = 1,
    JSMessageTypeAttributeJustifyCenter,
    JSMessageTypeAttributeJustifyRight,
    JSMessageTypeAttributeJustifyFull,
    JSMessageTypeAttributeBlod,
    JSMessageTypeAttributeBlockquote,
    JSMessageTypeAttributeItalic,
    JSMessageTypeAttributeSubscript,
    JSMessageTypeAttributeUnderline,
    JSMessageTypeAttributeSuperscript,
    JSMessageTypeAttributeStrikeThrough,
    JSMessageTypeAttributeUnorderedList,
    JSMessageTypeAttributeOrderedList,
    JSMessageTypeAttributeHorizontalRule,
    JSMessageTypeAttributeIndent,
    JSMessageTypeAttributeOutdent,
    JSMessageTypeAttributeFontSize,
    JSMessageTypeAttributeHeading,
    JSMessageTypeAttributeParagraph,
    JSMessageTypeAttributeFormating,
    
    JSMessageTypeImageInsertLocal = 200,
    JSMessageTypeImageInsertRemote,
    JSMessageTypeImageReplaceLocalWithRemote,
    JSMessageTypeImageUpdate,
    JSMessageTypeImageUpdateMeta,
    JSMessageTypeImageSetProgress,
    JSMessageTypeImageMarkUploadFailed,
    JSMessageTypeImageUnmarkUploadFailed,
    JSMessageTypeImageRemove,
    JSMessageTypeImageSetEditText,
    
    JSMessageTypeVideoInsertLocal = 300,
    JSMessageTypeVideoInsertRemote,
    JSMessageTypeVideoInsertProgressPoster,
    JSMessageTypeVideoSetProgress,
    JSMessageTypeVideoReplaceLocalWithRemote,
    JSMessageTypeVideoMarkUploadFailed,
    JSMessageTypeVideoUnmarkUploadFailed,
    JSMessageTypeVideoRemove,
    JSMessageTypeVideoSetVideoPressLinks,
    JSMessageTypeVideoPauseAll,
    
    JSMessageTypeLinkInsert = 400,
    JSMessageTypeLinkUpdate,
    JSMessageTypeLinkUnlink,
    JSMessageTypeLinkQuick
    
};

@interface LBEditorToolBarButton : UIButton

@property (nonatomic, readonly, assign) JSMessageType type;

+ (instancetype)buttonWithFrame:(CGRect)frame normalImage:(UIImage *) normalImage selectedImage:(UIImage *) selectedImage type:(JSMessageType)type;
- (instancetype)initWithFrame:(CGRect)frame normalImage:(UIImage *) normalImage selectedImage:(UIImage *) selectedImage type:(JSMessageType)type;

@end
