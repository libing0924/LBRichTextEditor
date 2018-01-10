//
//  ZBEditorViewController.m
//  hhty
//
//  Created by smufs on 2017/8/6.
//  Copyright © 2017年 Yesterday. All rights reserved.
//

#import "ZBEditorViewController.h"
#import <Photos/Photos.h>
#import "WPEditorView.h"
//#import "ZBReleaseTrainingViewModel.h"
#import "ZBFontSelectController.h"
#import "UIViewController+LBAnimator.h"

@interface WPEditorViewController ()

@property (nonatomic, strong, readwrite) WPEditorView *editorView;

@end

@interface ZBEditorViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) ZBReleaseTrainingViewModel *viewModel;

// 绑定image和image的progress
@property (nonatomic, strong) NSMutableDictionary *mediaAdded;

@end


@implementation ZBEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bodyPlaceholderText = @"请编辑内容...";
}

- (void)editorDidPressMedia
{
    [self showPhotoPicker];
}

- (void)showPhotoPicker
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.navigationBar.translucent = NO;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        NSURL *assetURL = info[UIImagePickerControllerReferenceURL];
        [self addAssetToContent:assetURL];
    }];
    
}

- (void)addAssetToContent:(NSURL *)assetURL
{
    PHFetchResult *assets = [PHAsset fetchAssetsWithALAssetURLs:@[assetURL] options:nil];
    if (assets.count < 1) {
        return;
    }
    PHAsset *asset = [assets firstObject];
    
    if (asset.mediaType == PHAssetMediaTypeImage) {
        [self addImageAssetToContent:asset];
    }
}

- (void)addImageAssetToContent:(PHAsset *)asset
{
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.synchronous = NO;
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                      options:options
                                                resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                    [self addImageDataToContent:imageData];
                                                }];
    
}

- (void)addImageDataToContent:(NSData *)imageData
{
    NSString *imageID = [[NSUUID UUID] UUIDString];
    NSString *path = [NSString stringWithFormat:@"%@/%@.jpg", NSTemporaryDirectory(), imageID];
    [imageData writeToFile:path atomically:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.editorView insertLocalImage:[[NSURL fileURLWithPath:path] absoluteString] uniqueId:imageID];
    });
    
    // upload image
    UIImage *originImage = [UIImage imageWithData:imageData];
    UIImage *image = [UIImage scaleImage:originImage toKb:2 * 1024];
    
    [self.viewModel UploadImageWithImages:@[image] callBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        if (result.status == NetworkModelStatusTypeSuccess)
        {
            [self.editorView replaceLocalImageWithRemoteImage:result.jsonDict[@"url"] uniqueId:imageID mediaId:[@(arc4random()) stringValue]];
        }
        else
        {
            [self.editorView removeImage:imageID];
        }
    }];
}

//- (void)timerFireMethod:(NSTimer *)timer
//{
//    NSProgress *progress = (NSProgress *)timer.userInfo;
//    progress.completedUnitCount++;
//    NSString *imageID = progress.userInfo[@"imageID"];
//    if (imageID) {
//        [self.editorView setProgress:progress.fractionCompleted onImage:imageID];
//        // Uncomment this code if you need to test a failed image upload
//        //    if (progress.fractionCompleted >= 0.15){
//        //        [progress cancel];
//        //        [self.editorView markImage:imageID failedUploadWithMessage:@"Failed"];
//        //        [timer invalidate];
//        //    }
//        if (progress.fractionCompleted >= 1) {
//            [self.editorView replaceLocalImageWithRemoteImage:[[NSURL fileURLWithPath:progress.userInfo[@"url"]] absoluteString] uniqueId:imageID mediaId:[@(arc4random()) stringValue]];
//            [timer invalidate];
//        }
//        return;
//    }
//}


- (ZBReleaseTrainingViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [[ZBReleaseTrainingViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

// 实现父类的图片点击回调
- (void)editorViewController:(WPEditorViewController*)editorViewController
                 imageTapped:(NSString *)imageId
                         url:(NSURL *)url
                   imageMeta:(WPImageMeta *)imageMeta
{
    if (imageId.length == 0) {
        [self showImageDetailsForImageMeta:imageMeta];
    } else {
//        [self showPromptForImageWithID:imageId];
    }
}

// 编辑图片
- (void)showImageDetailsForImageMeta:(WPImageMeta *)imageMeta
{
    
}

// 字体
- (void)setFontSize{
    
    ZBFontSelectController *vc = [ZBFontSelectController new];
    
    [self lb_presentViewController:vc animateStyle:LBTransitionAnimatorFromBottomStyle delegate:nil presentFrame:CGRectMake(0, SCREEN_HEIGHT - 35 * 4, SCREEN_WIDTH, 35 * 4) backgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] animated:YES];
    
    __weak typeof(self) weakSelf = self;
    vc.selectFontBlock = ^(NSInteger tag) {
        
        if (tag == 1) [weakSelf.editorView setFontSize:1];
        if (tag == 2) [weakSelf.editorView setFontSize:3];
        if (tag == 3) [weakSelf.editorView setFontSize:5];
        if (tag == 4) [weakSelf.editorView setFontSize:7];
        
    };

//    [self.editorView heading1];
//    [self.editorView heading2];
//    [self.editorView heading3];
//    [self.editorView heading4];
//    [self.editorView heading5];
//    [self.editorView heading6];
//    // 正常
//    [self.editorView setParagraph];
    
}

// 加载用户编辑的html
- (void)editorDidFinishLoadingDOM {
 
    if (self.htmlStr)
    {
        [self setBodyText:self.htmlStr];
    }
}

// 取消上传
//- (void)showPromptForImageWithID:(NSString *)imageId
//{
//    if (imageId.length == 0){
//        return;
//    }
//    
//    __weak __typeof(self)weakSelf = self;
//    UITraitCollection *traits = self.navigationController.traitCollection;
//    NSProgress *progress = self.mediaAdded[imageId];
//    UIAlertController *alertController;
//    if (traits.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//        alertController = [UIAlertController alertControllerWithTitle:nil
//                                                              message:nil
//                                                       preferredStyle:UIAlertControllerStyleAlert];
//    } else {
//        alertController = [UIAlertController alertControllerWithTitle:nil
//                                                              message:nil
//                                                       preferredStyle:UIAlertControllerStyleActionSheet];
//    }
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
//                                                           style:UIAlertActionStyleCancel
//                                                         handler:^(UIAlertAction *action){}];
//    [alertController addAction:cancelAction];
//    
//    if (!progress.cancelled){
//        UIAlertAction *stopAction = [UIAlertAction actionWithTitle:@"Stop Upload"
//                                                             style:UIAlertActionStyleDestructive
//                                                           handler:^(UIAlertAction *action){
//                                                               [weakSelf.editorView removeImage:weakSelf.selectedMediaID];
//                                                           }];
//        [alertController addAction:stopAction];
//    } else {
//        UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"Remove Image"
//                                                               style:UIAlertActionStyleDestructive
//                                                             handler:^(UIAlertAction *action){
//                                                                 [weakSelf.editorView removeImage:weakSelf.selectedMediaID];
//                                                             }];
//        
//        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry Upload"
//                                                              style:UIAlertActionStyleDefault
//                                                            handler:^(UIAlertAction *action){
//                                                                NSProgress * progress = [[NSProgress alloc] initWithParent:nil userInfo:@{@"imageID":self.selectedMediaID}];
//                                                                progress.totalUnitCount = 100;
//                                                                [NSTimer scheduledTimerWithTimeInterval:0.1
//                                                                                                 target:self
//                                                                                               selector:@selector(timerFireMethod:)
//                                                                                               userInfo:progress
//                                                                                                repeats:YES];
//                                                                weakSelf.mediaAdded[weakSelf.selectedMediaID] = progress;
//                                                                [weakSelf.editorView unmarkImageFailedUpload:weakSelf.selectedMediaID];
//                                                            }];
//        [alertController addAction:removeAction];
//        [alertController addAction:retryAction];
//    }
//    
//    self.selectedMediaID = imageId;
//    [self.navigationController presentViewController:alertController animated:YES completion:nil];
//}

@end
