//
//  LBWebViewJavaScriptBridge+RichEditor.m
//  LBRichTextEditor-Example
//
//  Created by 李冰 on 2018/1/9.
//  Copyright © 2018年 李冰. All rights reserved.
//

#import "LBEditorMessageHelper.h"
#import "HRColorUtil.h"

// 基本属性
NSString * const JSMessageJustifyLeft        = @"ZSSEditor.setJustifyLeft();";
NSString * const JSMessageJustifyCenter      = @"ZSSEditor.setJustifyCenter();";
NSString * const JSMessageJustifyRight       = @"ZSSEditor.setJustifyRight();";
NSString * const JSMessageJustifyFull        = @"ZSSEditor.setJustifyFull();";
NSString * const JSMessageBlod               = @"ZSSEditor.setBold();";
NSString * const JSMessageBlockquote         = @"ZSSEditor.setBlockquote();";
NSString * const JSMessageItalic             = @"ZSSEditor.setItalic();";
NSString * const JSMessageSubscript          = @"ZSSEditor.setSubscript();";
NSString * const JSMessageUnderline          = @"ZSSEditor.setUnderline();";
NSString * const JSMessageSuperscript        = @"ZSSEditor.setSuperscript();";
NSString * const JSMessageStrikeThrough      = @"ZSSEditor.setStrikeThrough();";
NSString * const JSMessageUnorderedList      = @"ZSSEditor.setUnorderedList();";
NSString * const JSMessageOrderedList        = @"ZSSEditor.setOrderedList();";
NSString * const JSMessageHorizontalRule     = @"ZSSEditor.setHorizontalRule();";
NSString * const JSMessageIndent             = @"ZSSEditor.setIndent();";
NSString * const JSMessageOutdent            = @"ZSSEditor.setOutdent();";
NSString * const JSMessageFontSize           = @"ZSSEditor.setFontSize(%ld);"; // 1-15
NSString * const JSMessageHeading            = @"ZSSEditor.setHeading('%@');"; // h1 h2 h3 h4 h5 h6
NSString * const JSMessageParagraph          = @"ZSSEditor.setParagraph()";
NSString * const JSMessageFormating          = @"ZSSEditor.removeFormating();";
NSString * const JSMessageTextColor          = @"ZSSEditor.setTextColor(\"%@\");";
NSString * const JSMessageBackgroundColor    = @"ZSSEditor.setBackgroundColor(\"%@\");";
// image
NSString * const JSMessageInsertLocalImage              = @"ZSSEditor.insertLocalImage(\"%@\", \"%@\");";
NSString * const JSMessageInsertRemoteImage             = @"ZSSEditor.insertImage(\"%@\", \"%@\");";
NSString * const JSMessageReplaceLocalImageWithRemote   = @"ZSSEditor.replaceLocalImageWithRemoteImage(\"%@\", \"%@\", %@);";
NSString * const JSMessageUpdateImage                   = @"ZSSEditor.updateImage(\"%@\", \"%@\");";
NSString * const JSMessageUpdateImageMeta               = @"ZSSEditor.updateCurrentImageMeta(\"%@\");";
NSString * const JSMessageSetProgressOnImage               = @"ZSSEditor.setProgressOnImage(\"%@\", %f);";
NSString * const JSMessageMarkImageUploadFailed         = @"ZSSEditor.markImageUploadFailed(\"%@\", \"%@\");";
NSString * const JSMessageUnmarkImageUploadFailed       = @"ZSSEditor.unmarkImageUploadFailed(\"%@\");";
NSString * const JSMessageRemoveImage                   = @"ZSSEditor.removeImage(\"%@\");";
NSString * const JSMessageSetImageEditText              = @"ZSSEditor.localizedEditText = \"%@\"";
// video
NSString * const JSMessageInsertVideo                       = @"ZSSEditor.insertVideo(\"%@\", \"%@\", \"%@\");";
NSString * const JSMessageInsertProgressVideoPosterImage    = @"ZSSEditor.insertInProgressVideoWithIDUsingPosterImage(\"%@\", \"%@\");";
NSString * const JSMessageSetProgressOnVideo                   = @"ZSSEditor.setProgressOnVideo(\"%@\", %f);";
NSString * const JSMessageReplaceLocalVideoWithRemote       = @"ZSSEditor.replaceLocalVideoWithRemoteVideo(\"%@\", \"%@\", \"%@\", \"%@\");";
NSString * const JSMessageMarkVideoUploadFailed             = @"ZSSEditor.markVideoUploadFailed(\"%@\", \"%@\");";
NSString * const JSMessageUnmarkVideoUploadFailed           = @"ZSSEditor.unmarkVideoUploadFailed(\"%@\");";
NSString * const JSMessageRemoveVideo                       = @"ZSSEditor.removeVideo(\"%@\");";
NSString * const JSMessageSetVideoPressLinks                = @"ZSSEditor.setVideoPressLinks(\"%@\", \"%@\", \"%@\");";
NSString * const JSMessagePauseAllVideos                    = @"ZSSEditor.pauseAllVideos();";
// link
NSString * const JSMessageInsertLink    = @"ZSSEditor.insertLink(\"%@\",\"%@\");";
NSString * const JSMessageUpdateLink    = @"ZSSEditor.updateLink(\"%@\",\"%@\");";
NSString * const JSMessageUnlink        = @"ZSSEditor.unlink();";
NSString * const JSMessageQuickLink     = @"ZSSEditor.quickLink();";
// control
NSString * const JSMessageUndo = @"ZSSEditor.undo();";
NSString * const JSMessageRedo = @"ZSSEditor.redo();";
NSString * const JSMessageRestoreRange = @"ZSSEditor.restoreRange();";
NSString * const JSMessageBackupRange = @"ZSSEditor.backupRange();";
NSString * const JSMessageGetSelectedText = @"ZSSEditor.getSelectedText();";
NSString * const JSMessageInsertHTML = @"ZSSEditor.insertHTML(\"%@\");";

@implementation LBEditorMessageHelper

+ (instancetype)defaultBrige:(id)webView {
    
    LBEditorMessageHelper *brige = [[LBEditorMessageHelper alloc] initWithWebView:webView];
    
    // add callback
    [brige _addCallbackHandler];
    
    return brige;
}

- (void)handleJSMessage:(JSMessageType)type {
    
}

#pragma mark - invoke JavaScript
- (void)alignLeft {
    
}
- (void)alignCenter {
    
}
- (void)alignRight {
    
}
- (void)alignFull {
    
}
- (void)setBold {
    
}
- (void)setBlockQuote {
    
}
- (void)setItalic {
    
}
- (void)setSubscript {
    
}
- (void)setUnderline {
    
}
- (void)setSuperscript {
    
}
- (void)setStrikethrough {
    
}
- (void)setUnorderedList {
    
}
- (void)setOrderedList {
    
}
- (void)setHR {
    
}
- (void)setIndent {
    
}
- (void)setOutdent {
    
}
- (void)setParagraph {
    
}
- (void)removeFormat {
    
}
- (void)setHeading:(NSString *)head {
    
}
- (void)setFontSize:(NSInteger)size {
    
}
- (void)setTextColor:(UIColor *)color {
    
    NSString *hex = [NSString stringWithFormat:@"#%06x",HexColorFromUIColor(color)];
    NSString *trigger = [NSString stringWithFormat:JSMessageTextColor, hex];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)setBackgroundColor:(UIColor *)color {
    
    NSString *hex = [NSString stringWithFormat:@"#%06x",HexColorFromUIColor(color)];
    NSString *trigger = [NSString stringWithFormat:JSMessageBackgroundColor, hex];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)insertHTML:(NSString *)html {
    NSString *cleanedHTML = [self addSlashes:html];
    NSString *trigger = [NSString stringWithFormat:JSMessageInsertHTML, cleanedHTML];
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)insertLocalImage:(NSString *)url uniqueId:(NSString *)uniqueId {
    
    NSString *trigger = [NSString stringWithFormat:JSMessageInsertLocalImage, uniqueId, url];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)insertImage:(NSString *)url alt:(NSString *)alt {
    
    NSString *trigger = [NSString stringWithFormat:JSMessageInsertRemoteImage, url, alt];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)replaceLocalImageWithRemoteImage:(NSString *)url uniqueId:(NSString *)uniqueId mediaId:(NSString *)mediaId {
    
    NSString *trigger = [NSString stringWithFormat:JSMessageReplaceLocalImageWithRemote, uniqueId, url, mediaId];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)updateImage:(NSString *)url alt:(NSString *)alt {
    
    NSString *trigger = [NSString stringWithFormat:JSMessageUpdateImage, url, alt];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)updateCurrentImageMeta:(WPImageMeta *)imageMeta {
    
    NSString *jsonString = [imageMeta jsonStringRepresentation];
    jsonString = [self addSlashes:jsonString];
    NSString *trigger = [NSString stringWithFormat:JSMessageUpdateImageMeta, jsonString];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)setProgress:(double) progress onImage:(NSString *)uniqueId {
    
    NSString *trigger = [NSString stringWithFormat:JSMessageSetProgressOnImage, uniqueId, progress];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)markImage:(NSString *)uniqueId failedUploadWithMessage:(NSString *) message {
    
    NSString *trigger = [NSString stringWithFormat:JSMessageMarkImageUploadFailed, uniqueId, message];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)unmarkImageFailedUpload:(NSString *)uniqueId {
    
    NSString *trigger = [NSString stringWithFormat:JSMessageUnmarkImageUploadFailed, uniqueId];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)removeImage:(NSString *)uniqueId {
    
    NSString *trigger = [NSString stringWithFormat:JSMessageRemoveImage, uniqueId];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)setImageEditText:(NSString *)text {
    
    NSParameterAssert([text isKindOfClass:[NSString class]]);
    NSString *trigger = [NSString stringWithFormat:JSMessageSetImageEditText, text];
    [self evaluatingJavaScriptFromString:trigger];
}

- (void)insertVideo:(NSString *)videoURL posterImage:(NSString *)posterImageURL alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"ZSSEditor.insertVideo(\"%@\", \"%@\", \"%@\");", videoURL, posterImageURL, alt];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)insertInProgressVideoWithID:(NSString *)uniqueId usingPosterImage:(NSString *)posterImageURL {
    NSString *trigger = [NSString stringWithFormat:@"ZSSEditor.insertInProgressVideoWithIDUsingPosterImage(\"%@\", \"%@\");", uniqueId, posterImageURL];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)setProgress:(double)progress onVideo:(NSString *)uniqueId {
    NSString *trigger = [NSString stringWithFormat:@"ZSSEditor.setProgressOnVideo(\"%@\", %f);", uniqueId, progress];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)replaceLocalVideoWithID:(NSString *)uniqueID forRemoteVideo:(NSString *)videoURL remotePoster:(NSString *)posterURL videoPress:(NSString *)videoPressID {
    NSString *videoPressSafeID = videoPressID;
    if (!videoPressSafeID) {
        videoPressSafeID = @"";
    }
    NSString *posterURLSafe = posterURL;
    if (!posterURLSafe) {
        posterURLSafe = @"";
    }
    NSString *trigger = [NSString stringWithFormat:@"ZSSEditor.replaceLocalVideoWithRemoteVideo(\"%@\", \"%@\", \"%@\", \"%@\");", uniqueID, videoURL, posterURLSafe, videoPressSafeID];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)markVideo:(NSString *)uniqueId failedUploadWithMessage:(NSString *) message {
    NSString *trigger = [NSString stringWithFormat:@"ZSSEditor.markVideoUploadFailed(\"%@\", \"%@\");", uniqueId, message];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)unmarkVideoFailedUpload:(NSString *)uniqueId {
    NSString *trigger = [NSString stringWithFormat:@"ZSSEditor.unmarkVideoUploadFailed(\"%@\");", uniqueId];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)removeVideo:(NSString *)uniqueId {
    NSString *trigger = [NSString stringWithFormat:@"ZSSEditor.removeVideo(\"%@\");", uniqueId];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)setVideoPress:(NSString *)videoPressID source:(NSString *)videoURL poster:(NSString *)posterURL {
    NSString *trigger = [NSString stringWithFormat:@"ZSSEditor.setVideoPressLinks(\"%@\", \"%@\", \"%@\");", videoPressID, videoURL, posterURL];
    [self evaluatingJavaScriptFromString:trigger];
}
- (void)pauseAllVideos {
    NSString *trigger = [NSString stringWithFormat:@"ZSSEditor.pauseAllVideos();"];
    [self evaluatingJavaScriptFromString:trigger];
}

- (void)insertLink:(NSString *)url title:(NSString *)title {
    
    NSParameterAssert([url isKindOfClass:[NSString class]]);
    NSParameterAssert([title isKindOfClass:[NSString class]]);
    
    url = [self normalizeURL:url];
    NSString *trigger = [NSString stringWithFormat:JSMessageInsertLink, url, title];
    [self evaluatingJavaScriptFromString:trigger];
    
}
- (void)updateLink:(NSString *)url title:(NSString *)title {
    
    NSParameterAssert([url isKindOfClass:[NSString class]]);
    NSParameterAssert([title isKindOfClass:[NSString class]]);
    
    url = [self normalizeURL:url];
    NSString *trigger = [NSString stringWithFormat:JSMessageUpdateLink, url, title];
    [self evaluatingJavaScriptFromString:trigger];
    
}
- (void)quickLink {
    [self evaluatingJavaScriptFromString:JSMessageUnlink];
}
- (void)removeLink {
    [self evaluatingJavaScriptFromString:JSMessageQuickLink];
}

- (void)undo {
    [self evaluatingJavaScriptFromString:JSMessageUndo];
}
- (void)redo {
    [self evaluatingJavaScriptFromString:JSMessageRedo];
}
- (void)restoreSelection {
    [self evaluatingJavaScriptFromString:JSMessageRestoreRange];
}
- (void)saveSelection {
    [self evaluatingJavaScriptFromString:JSMessageBackupRange];
}
- (NSString *)getSelectedText {
    
    __block NSString *text = nil;
    [self evaluatingJavaScriptFromString:JSMessageGetSelectedText handler:^(id result) {
        
        text = result;
    }];
    
    return text;
}

#pragma mark - JavaScript Callback
- (void) _addCallbackHandler {
    
    __weak typeof(self) weakSelf = self;
    [self addScriptURLSchemeHandler:JSCallbackInputScheme handler:^(NSURL *URL, id parameter) {
        
        if ([weakSelf.editDelegate respondsToSelector:@selector(javaScriptBridgeTextDidChange:fieldId:yOffset:height:)]) {
            
            [weakSelf.editDelegate javaScriptBridgeTextDidChange:weakSelf fieldId:parameter[@"id"] yOffset:[parameter[@"yOffset"] floatValue] height:[parameter[@"height"] floatValue]];
        }
    }];
    [self addScriptURLSchemeHandler:JSCallbackLinkTapScheme handler:^(NSURL *URL, id parameter) {
        
        if ([weakSelf.editDelegate respondsToSelector:@selector(javaScriptBridge:linkTapped:title:)]) {
            
            NSString *urlStr = parameter[@"url"];
            NSString *title = parameter[@"title"];
            
            NSURL *url = [NSURL URLWithString:urlStr];
            
            [weakSelf.editDelegate javaScriptBridge:weakSelf linkTapped:url title:title];
        }
    }];
    [self addScriptURLSchemeHandler:JSCallbackImageTapScheme handler:^(NSURL *URL, id parameter) {
        
        if ([weakSelf.editDelegate respondsToSelector:@selector(javaScriptBridge:imageTapped:url:imageMeta:)]) {
            
            NSString *urlStr = parameter[@"url"];
            NSString *ID = parameter[@"id"];
            NSString *meta = parameter[@"meta"];
            
            NSURL *url = [NSURL URLWithString:urlStr];
            WPImageMeta *imageMeta = [WPImageMeta imageMetaFromJSONString:meta];
            
            [weakSelf.editDelegate javaScriptBridge:weakSelf imageTapped:ID url:url imageMeta:imageMeta];
        }
    }];
    [self addScriptURLSchemeHandler:JSCallbackVideoTapScheme handler:^(NSURL *URL, id parameter) {
        
        if ([weakSelf.editDelegate respondsToSelector:@selector(javaScriptBridge:videoTapped:url:)]) {
            
            NSString *urlStr = parameter[@"url"];
            NSString *ID = parameter[@"id"];
            
            NSURL *url = [NSURL URLWithString:urlStr];
            [weakSelf.editDelegate javaScriptBridge:weakSelf videoTapped:ID url:url];
        }
    }];
    [self addScriptURLSchemeHandler:JSCallbackNewFieldScheme handler:^(NSURL *URL, id parameter) {
        
        if ([weakSelf.editDelegate respondsToSelector:@selector(javaScriptBridge:newField:)]) {
            
            // id为zss_field_title、zss_field_content其中之一
            [weakSelf.editDelegate javaScriptBridge:weakSelf newField:parameter[@"id"]];
        }
    }];
    [self addScriptURLSchemeHandler:JSCallbackSelectionChangeScheme handler:^(NSURL *URL, id parameter) {
        
        if ([weakSelf.editDelegate respondsToSelector:@selector(javaScriptBridge:selectionChancgeYOffset:height:)]) {
            
            [weakSelf.editDelegate javaScriptBridge:weakSelf selectionChancgeYOffset:[parameter[@"yOffset"] floatValue] height:[parameter[@"height"] floatValue]];
        }
    }];
    [self addScriptURLSchemeHandler:JSCallbackDomLoadedScheme handler:^(NSURL *URL, id parameter) {
        
        [weakSelf insertHTML:@"<b>我啊</b>"];
        
        if ([weakSelf.editDelegate respondsToSelector:@selector(javaScriptBridgeDidFinishLoadingDOM:)]) {
            
            [weakSelf.editDelegate javaScriptBridgeDidFinishLoadingDOM:weakSelf];
        }
        
        
    }];
    [self addScriptURLSchemeHandler:JSCallbackImageReplacedScheme handler:^(NSURL *URL, id parameter) {
        
        if ([weakSelf.editDelegate respondsToSelector:@selector(javaScriptBridge:imageReplaced:)]) {
            
            [weakSelf.editDelegate javaScriptBridge:weakSelf imageReplaced:parameter[@"id"]];
        }
    }];
    [self addScriptURLSchemeHandler:JSCallbackVideoReplacedScheme handler:^(NSURL *URL, id parameter) {
        
        if ([weakSelf.editDelegate respondsToSelector:@selector(javaScriptBridge:videoReplaced:)]) {
            
            [weakSelf.editDelegate javaScriptBridge:weakSelf videoReplaced:parameter[@"id"]];
        }
    }];
    [self addScriptURLSchemeHandler:JSCallbackVideoFullScreenStartedScheme handler:^(NSURL *URL, id parameter) {
        
        if ([weakSelf.editDelegate respondsToSelector:@selector(javaScriptBridge:videoStardFullScreen:)]) {
            
            [weakSelf.webView stringByEvaluatingJavaScriptFromString:@"ZSSEditor.backupRange();"];
            [weakSelf.editDelegate javaScriptBridge:weakSelf videoStardFullScreen:nil];
        }
    }];
    [self addScriptURLSchemeHandler:JSCallbackVideoFullScreenEndedScheme handler:^(NSURL *URL, id parameter) {
        
        if ([weakSelf.editDelegate respondsToSelector:@selector(javaScriptBridge:videoEndedFullScreen:)]) {
            
            [weakSelf.editDelegate javaScriptBridge:weakSelf videoEndedFullScreen:nil];
            [weakSelf.webView stringByEvaluatingJavaScriptFromString:@"ZSSEditor.restoreRange();"];
        }
    }];
    [self addScriptURLSchemeHandler:JSCallbackVideoPressInfoRequestScheme handler:^(NSURL *URL, id parameter) {
        
        if ([weakSelf.editDelegate respondsToSelector:@selector(javaScriptBridge:videoPressInfoRequest:)]) {
            
            [weakSelf.editDelegate javaScriptBridge:weakSelf videoPressInfoRequest:parameter[@"id"]];
        }
    }];
    [self addScriptURLSchemeHandler:JSCallbackMediaRemovedScheme handler:^(NSURL *URL, id parameter) {
        
        if ([weakSelf.editDelegate respondsToSelector:@selector(javaScriptBridge:mediaRemoved:)]) {
            
            [weakSelf.editDelegate javaScriptBridge:weakSelf mediaRemoved:parameter[@"id"]];
        }
    }];
    [self addScriptURLSchemeHandler:JSCallbackPasteScheme handler:^(NSURL *URL, id parameter) {
        
        if ([weakSelf.editDelegate respondsToSelector:@selector(javaScriptBridge:imagePasted:)]) {
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            
            [weakSelf.editDelegate javaScriptBridge:weakSelf imagePasted:pasteboard.image];
        }
    }];
    [self addScriptURLSchemeHandler:JSCallbackFocusInScheme handler:^(NSURL *URL, id parameter) {
        
        if ([weakSelf.editDelegate respondsToSelector:@selector(javaScriptBridge:fieldFocusedIn:)]) {
            
            [weakSelf.editDelegate javaScriptBridge:weakSelf fieldFocusedIn:parameter[@"id"]];
        }
    }];
    [self addScriptURLSchemeHandler:JSCallbackFocusOutScheme handler:^(NSURL *URL, id parameter) {
        
        if ([weakSelf.editDelegate respondsToSelector:@selector(javaScriptBridge:fieldFocusedOut:)]) {
            
            [weakSelf.editDelegate javaScriptBridge:weakSelf fieldFocusedOut:parameter[@"id"]];
        }
    }];
    
    [self addScriptURLSchemeHandler:JSCallbackSelectionStyleScheme handler:^(NSURL *URL, id parameter) {
        
        
        NSString *styles = [[URL resourceSpecifier] stringByReplacingOccurrencesOfString:@"//" withString:@""];
        
        [weakSelf processStyles:styles];
    }];
    [self addScriptURLSchemeHandler:JSCallbackLogScheme handler:^(NSURL *URL, id parameter) {
        
        NSLog(@"%@", parameter[@"msg"]);
    }];
    [self addScriptURLSchemeHandler:JSCallbackLogErrorScheme handler:^(NSURL *URL, id parameter) {
        
        NSString *ErrorFormat = [NSString stringWithFormat:@"WebEditor error:\r\n  In file: %@\r\n  In line: %@\r\n  %@", parameter[@"url"], parameter[@"line"], parameter[@"msg"]];
        NSLog(@"%@", ErrorFormat);
    }];
}

#pragma mark - assist function
/**
 *  @brief      Adds slashes to the specified HTML string, to prevent injections when calling JS
 *              code.
 *
 *  @param      html        The HTML string to add slashes to.  Cannot be nil.
 *
 *  @returns    The HTML string with the added slashes.
 */
- (NSString *)addSlashes:(NSString *)html {
    html = [html stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    html = [html stringByReplacingOccurrencesOfString:@"\r"  withString:@"\\r"];
    html = [html stringByReplacingOccurrencesOfString:@"\n"  withString:@"\\n"];
    
    return html;
}

- (NSString*)normalizeURL:(NSString*)url {
    static NSString* const kDefaultScheme = @"http://";
    static NSString* const kURLSchemePrefix = @"://";
    
    NSString* normalizedURL = url;
    NSRange substringRange = [url rangeOfString:kURLSchemePrefix];
    
    if (substringRange.length == 0) {
        normalizedURL = [kDefaultScheme stringByAppendingString:url];
    }
    
    return normalizedURL;
}

- (NSString *)stringByDecodingURLFormat:(NSString *)string {
    NSString *result = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByRemovingPercentEncoding];
    return result;
}

- (void)processStyles:(NSString *)styles {
    NSArray *styleStrings = [styles componentsSeparatedByString:kDefaultURLParameterSeparator];
    NSMutableArray *itemsModified = [[NSMutableArray alloc] init];
    
    self.selectedImageURL = nil;
    self.selectedImageAlt = nil;
    self.selectedLinkURL = nil;
    self.selectedLinkTitle = nil;
    
    for (NSString *styleString in styleStrings) {
        NSString *updatedItem = styleString;
        if ([styleString hasPrefix:@"link:"]) {
            updatedItem = @"link";
            self.selectedLinkURL = [self stringByDecodingURLFormat:[styleString stringByReplacingOccurrencesOfString:@"link:" withString:@""]];
        } else if ([styleString hasPrefix:@"link-title:"]) {
            self.selectedLinkTitle = [self stringByDecodingURLFormat:[styleString stringByReplacingOccurrencesOfString:@"link-title:" withString:@""]];
        } else if ([styleString hasPrefix:@"image:"]) {
            updatedItem = @"image";
            self.selectedImageURL = [styleString stringByReplacingOccurrencesOfString:@"image:" withString:@""];
        } else if ([styleString hasPrefix:@"image-alt:"]) {
            self.selectedImageAlt = [self stringByDecodingURLFormat:[styleString stringByReplacingOccurrencesOfString:@"image-alt:" withString:@""]];
        }
        [itemsModified addObject:updatedItem];
    }
    
    styleStrings = [NSArray arrayWithArray:itemsModified];
    
    if ([self.editDelegate respondsToSelector:@selector(javaScriptBridge:stylesForCurrentSelection:)])
    {
        [self.editDelegate javaScriptBridge:self stylesForCurrentSelection:styleStrings];
    }
}

// 重写解析URL的query参数集
- (NSDictionary *)parseParametersWithURL:(NSURL *)url {
    
    NSParameterAssert([url isKindOfClass:[NSURL class]]);
    
    NSString *query = url.resourceSpecifier;
    
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
                [tmp setObject:[self stringByDecodingURLFormat:keyValue.lastObject] forKey:keyValue.firstObject];
                continue;
            }
        }
    }
    
    return tmp.copy;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self insertHTML:@"<b>我啊</b>"];
}

@end
