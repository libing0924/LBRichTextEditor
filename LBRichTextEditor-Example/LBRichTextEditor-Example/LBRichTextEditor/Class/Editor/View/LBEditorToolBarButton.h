//
//  LBEditorToolBarButton.h
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/8.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JSMessageType) {
    
    JSMessageTypeAttributeJustifyLeft = 1, // 左对齐
    JSMessageTypeAttributeJustifyCenter, // 中间对齐
    JSMessageTypeAttributeJustifyRight, // 右对齐
    JSMessageTypeAttributeJustifyFull, //
    JSMessageTypeAttributeBlod, // 黑体
    JSMessageTypeAttributeBlockquote, // 引用
    JSMessageTypeAttributeItalic, // 斜体
    JSMessageTypeAttributeSubscript, // 下标
    JSMessageTypeAttributeUnderline, // 下划线
    JSMessageTypeAttributeSuperscript, // 上标
    JSMessageTypeAttributeStrikeThrough, //  横线
    JSMessageTypeAttributeUnorderedList, // 无序表
    JSMessageTypeAttributeOrderedList, // 有序列表
    JSMessageTypeAttributeHorizontalRule, //
    JSMessageTypeAttributeIndent, // 缩进
    JSMessageTypeAttributeOutdent, // 减少缩进
    JSMessageTypeAttributeFontSize, // 字体大小
    JSMessageTypeAttributeHeading, // H标签
    JSMessageTypeAttributeParagraph, // 段落
    JSMessageTypeAttributeFormating, // 格式化
    JSMessageTypeAttributeTextColor, // 字体颜色
    JSMessageTypeAttributeBackgroundColor, // 背景色
    
    JSMessageTypeImageInsertLocal = 200, // 插入本地图片
    JSMessageTypeImageInsertRemote, // 插入远程图片
    JSMessageTypeImageReplaceLocalWithRemote, // 替换本地图片为远程
    JSMessageTypeImageUpdate, // 图片更新
    JSMessageTypeImageUpdateMeta, // 更新图片元数据
    JSMessageTypeImageSetProgress, // 设置上传进度
    JSMessageTypeImageMarkUploadFailed, // 显示上传失败
    JSMessageTypeImageUnmarkUploadFailed, // 取消显示上传失败
    JSMessageTypeImageRemove, // 移除图片
    JSMessageTypeImageSetEditText, // 设置编辑显示文字
    
    JSMessageTypeVideoInsertLocal = 300, // 插入本地视频
    JSMessageTypeVideoInsertRemote, // 插入远端视频
    JSMessageTypeVideoInsertProgressPoster, // 设置封面
    JSMessageTypeVideoSetProgress, // 设置进度
    JSMessageTypeVideoReplaceLocalWithRemote, // 本地视频替换为远端
    JSMessageTypeVideoMarkUploadFailed, // 标记上传失败
    JSMessageTypeVideoUnmarkUploadFailed, // 标记上传成功
    JSMessageTypeVideoRemove, // 移除视频
    JSMessageTypeVideoSetVideoPressLinks, // 设置视频链接
    JSMessageTypeVideoPauseAll, // 暂停所有视频
    
    JSMessageTypeLinkInsert = 400, // 插入链接
    JSMessageTypeLinkUpdate, // 更新链接
    JSMessageTypeLinkUnlink, // 取消链接
    JSMessageTypeLinkQuick // 快速链接
    
};

@interface LBEditorToolBarButton : UIButton

@property (nonatomic, readonly, assign) JSMessageType type;

+ (instancetype)buttonWithFrame:(CGRect)frame normalImage:(UIImage *) normalImage selectedImage:(UIImage *) selectedImage type:(JSMessageType)type;
- (instancetype)initWithFrame:(CGRect)frame normalImage:(UIImage *) normalImage selectedImage:(UIImage *) selectedImage type:(JSMessageType)type;

@end
