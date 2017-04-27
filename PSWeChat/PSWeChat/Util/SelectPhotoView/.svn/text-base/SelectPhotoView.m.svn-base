//
//  SelectPhotoView.m
//  QianfengSchool
//
//  Created by chenhuan on 16/7/20.
//  Copyright © 2016年 Combanc. All rights reserved.
//

#import "SelectPhotoView.h"
#import "SelectPhotoFlowLayout.h"
#import "SelectPhotoCollectionViewCell.h"
#import "WSelectPhoto.h"
#import <CommonCrypto/CommonDigest.h>
#import "MWPhotoBrowser.h"
#import "MWPhoto.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "HJCActionSheet.h"

static NSString *const shareImageCellID = @"SHAREIMAGE_CELLID";

@interface SelectPhotoView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate, HJCActionSheetDelegate>

@property (nonatomic, strong) UICollectionView *shareImageCollectionView;/**<分享图片 */
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;/**<布局 */
@property (nonatomic, strong) NSMutableArray *selectImageMubArray;/**<选择的图片数组 */
@property (nonatomic, strong) NSMutableArray *imageSizeArray;/**图片的大小 */
@property (nonatomic, strong) NSMutableArray *imageFileNameArray;/**图片的文件名 */
@property (nonatomic, strong) NSMutableArray *imageUserNameArray;/**图片的重命名 */
@property (nonatomic, assign) NSInteger photoMaxCount;/**< 最多选择图片的个数*/
@property (nonatomic, assign) CGSize itemSize;/**cell的大小 */
@property (nonatomic, strong) NSMutableArray *placeholderArray;/**提示图片数组 */
@property (nonatomic, assign) NSInteger spaceOfLine;/**item间隔 */
@property (nonatomic, strong) NSMutableArray *MWPhotoArray;/**将图片转化为MWPhoto */
@end

@implementation SelectPhotoView

- (instancetype)initWithItemSize:(CGSize)size placeholderImage:(NSMutableArray *)imageArray selectPhotoMaxCount:(NSInteger)count passImageArray:(NSMutableArray *)array spaceOfline:(NSInteger)spaceOfLine {
    
    if (self = [super init]) {
        
        _itemSize = size;
        self.placeholderArray = [NSMutableArray arrayWithArray:imageArray];
        _photoMaxCount = count;
        _spaceOfLine = spaceOfLine;
        
        if (array.count > 0) {
            for (int i = 0; i < array.count; i++) {
                UIImage *image = array[i];
                NSData *imageData = UIImagePNGRepresentation(image);
                NSInteger length = [imageData length]/1024;
                [self.selectImageMubArray addObject:image];
                [self.imageSizeArray addObject:[NSString stringWithFormat:@"%ld",(long)length]];
                [self.imageFileNameArray addObject:[self getPhotoName]];
                [self.imageUserNameArray addObject:[self getPhotoName]];
            }
        }
        
        [self setUI];
    }
    return self;
}

#pragma mark - 懒加载

- (UICollectionViewFlowLayout *)layout {
    
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.minimumLineSpacing = _spaceOfLine;
        _layout.minimumInteritemSpacing = _spaceOfLine;
    }
    return _layout;
}

- (UICollectionView *)shareImageCollectionView {
    
    if (!_shareImageCollectionView) {
        _shareImageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _shareImageCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _shareImageCollectionView.delegate = self;
        _shareImageCollectionView.dataSource = self;
        _shareImageCollectionView.scrollEnabled = NO;
        _shareImageCollectionView.backgroundColor = [UIColor whiteColor];
        [_shareImageCollectionView registerClass:[SelectPhotoCollectionViewCell class] forCellWithReuseIdentifier:shareImageCellID];
    }
    return _shareImageCollectionView;
}

- (NSMutableArray *)placeholderArray {
    
    if (!_placeholderArray) {
        _placeholderArray = [[NSMutableArray alloc]init];
    }
    return _placeholderArray;
}

- (NSMutableArray *)selectImageMubArray {
    
    if (!_selectImageMubArray) {
        _selectImageMubArray = [[NSMutableArray alloc]init];
    }
    return _selectImageMubArray;
}

- (NSMutableArray *)imageFileNameArray {
    
    if (!_imageFileNameArray) {
        _imageFileNameArray = [[NSMutableArray alloc]init];
    }
    return _imageFileNameArray;
}

- (NSMutableArray *)imageSizeArray {
    
    if (!_imageSizeArray) {
        _imageSizeArray = [[NSMutableArray alloc]init];
    }
    return _imageSizeArray;
}

- (NSMutableArray *)imageUserNameArray {
    
    if (!_imageUserNameArray) {
        _imageUserNameArray = [[NSMutableArray alloc]init];
    }
    return _imageUserNameArray;
}

- (NSMutableArray *)MWPhotoArray {
    
    if (!_MWPhotoArray) {
        _MWPhotoArray = [[NSMutableArray alloc]init];
    }
    return _MWPhotoArray;
}

#pragma mark - 设置UI

- (void)setUI {
    
    //首次添加时默认高度为0
    [self addSubview:self.shareImageCollectionView];
    [self.shareImageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(self.spaceOfLine);
        make.right.equalTo(self.mas_right).offset(-self.spaceOfLine);
    }];
}

#pragma mark - CollectionViewDelegate && DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.selectImageMubArray.count == _photoMaxCount) {
        return self.selectImageMubArray.count;
    }else {
        return self.selectImageMubArray.count + self.placeholderArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shareImageCellID forIndexPath:indexPath];
    cell.deleteImgBtn.hidden = YES;
    
    if (indexPath.item < self.selectImageMubArray.count) {
        cell.deleteImgBtn.hidden = NO;
        cell.deleteImgBtn.tag = indexPath.item;
        [self setCellImageViewWithCell:cell image:self.selectImageMubArray[indexPath.item]];
    }else {
        [self setCellImageViewWithCell:cell image:self.placeholderArray[indexPath.item - self.selectImageMubArray.count]];
    }
    __weak typeof(self) weakSelf = self;
    [cell setDeleteImageBtnClick:^(UIButton *button) {
        [weakSelf.selectImageMubArray removeObjectAtIndex:indexPath.item];
        [weakSelf.imageUserNameArray removeObjectAtIndex:indexPath.item];
        [weakSelf.imageFileNameArray removeObjectAtIndex:indexPath.item];
        [weakSelf.imageSizeArray removeObjectAtIndex:indexPath.item];
        
        weakSelf.selectImageBlock(weakSelf.selectImageMubArray,weakSelf.imageFileNameArray,weakSelf.imageSizeArray,weakSelf.imageUserNameArray);
        [self.shareImageCollectionView reloadData];
    }];
    return cell;
}

- (void)setCellImageViewWithCell:(SelectPhotoCollectionViewCell *)cell image:(id)image {
    
    if ([[image class] isSubclassOfClass:[NSString class]]) {
        //传入的是图片名称
        cell.imageV.image = [UIImage imageNamed:image];
    }else if ([[image class] isSubclassOfClass:[NSURL class]]){
        //传入的是图片的URL地址
        [cell.imageV sd_setImageWithURL:image];
    }else if ([[image class] isSubclassOfClass:[UIImage class]]){
        //传入的是图片
        cell.imageV.image = image;
    }else {
        //传入的是压缩的图片
        cell.imageV.image = [UIImage imageWithData:image];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //如果有点击提示添加图片，则进入相机或者相册
    if (indexPath.item >= self.selectImageMubArray.count) {
        if (_showFlatAlertView) {
               HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"拍照", @"从手机相册选择", nil];
            // 2.显示出来
            [sheet show];
        } else {
            //点击提示选择相机或者相册
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self
                                                           cancelButtonTitle:@"取消"
                                                      destructiveButtonTitle:nil
                                                           otherButtonTitles:@"拍照", @"从手机相册选择",nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:self];
        }
        return;
    }
    
    //否则浏览图片
    if (self.MWPhotoArray.count > 0 ) {
        [self.MWPhotoArray removeAllObjects];
    }
    for (int i = 0; i < self.selectImageMubArray.count; i++) {
        MWPhoto *photos = [MWPhoto photoWithImage:self.selectImageMubArray[i]];
        [self.MWPhotoArray addObject:photos];
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = YES;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = NO;
    browser.isShowDeleteRightNavBtn = YES;
    [browser setCurrentPhotoIndex:indexPath.item];
    
    if (self.presentBlock) {
        self.presentBlock(browser);
    }
}

#pragma mark - flowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return _itemSize;
}
//cell的代理方法
- (void)deleteImageWithButton:(UIButton *)btn {
    
    [self.selectImageMubArray removeObjectAtIndex:btn.tag];
    [self.imageUserNameArray removeObjectAtIndex:btn.tag];
    [self.imageFileNameArray removeObjectAtIndex:btn.tag];
    [self.imageSizeArray removeObjectAtIndex:btn.tag];

    self.selectImageBlock(self.selectImageMubArray,self.imageFileNameArray,self.imageSizeArray,self.imageUserNameArray);
    [self.shareImageCollectionView reloadData];
}

#pragma mark - photobrowser代理方法
//告诉他有多少张图片
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    
    return self.MWPhotoArray.count;
}
//通过下标获取图片
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.MWPhotoArray.count) {
        return [self.MWPhotoArray objectAtIndex:index];
    }
    return nil;
}
- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    //返回
    if (self.dismissBlock) {
        self.dismissBlock(photoBrowser);
    }
}
//删除按钮点击回调
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
    
    [self.selectImageMubArray removeObjectAtIndex:index];
    [self.imageUserNameArray removeObjectAtIndex:index];
    [self.imageFileNameArray removeObjectAtIndex:index];
    [self.imageSizeArray removeObjectAtIndex:index];
    [self.MWPhotoArray removeObjectAtIndex:index];
    photoBrowser.displayActionButton = YES;
    photoBrowser.displayNavArrows = NO;
    photoBrowser.displaySelectionButtons = NO;
    photoBrowser.alwaysShowControls = NO;
    photoBrowser.zoomPhotosToFill = YES;
    photoBrowser.enableGrid = NO;
    photoBrowser.startOnGrid = NO;
    photoBrowser.enableSwipeToDismiss = NO;
    photoBrowser.autoPlayOnAppear = NO;
    photoBrowser.isShowDeleteRightNavBtn = YES;
    [photoBrowser reloadData];
    [self.shareImageCollectionView reloadData];
    
    if (_selectImageBlock) {
        self.selectImageBlock(self.selectImageMubArray,self.imageFileNameArray,self.imageSizeArray,self.imageUserNameArray);
    }
    
    if (self.MWPhotoArray.count == 0) {
        if (self.dismissBlock) {
            self.dismissBlock(photoBrowser);
        }
    }
}

#pragma mark -UIActionSheet代理方法
// 3.实现代理方法，需要遵守HJCActionSheetDelegate代理协议
- (void)hjcActionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self takePhoto];
    } else if (buttonIndex == 2) {
        [self addPhoto];
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self addPhoto];
    }
}

#pragma mark - 拍照方法
- (void)takePhoto {
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    if (self.presentBlock) {
        self.presentBlock(picker);
    }
}
- (void)addPhoto {
    
    WSelectPhotoPickerViewController *pickerVc = [[WSelectPhotoPickerViewController alloc] init];
    //跳转到相册界面
    if (self.presentBlock) {
        self.presentBlock(pickerVc);
    }
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = _photoMaxCount - _selectImageMubArray.count;
    
    __weak __typeof(self)weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        for (WSelectPhotoAssets *ass in assets) {

            if (weakSelf.selectImageMubArray.count > _photoMaxCount - 1) {
                break;
            }
            [weakSelf.selectImageMubArray addObject:ass.originImage];
            [weakSelf.imageFileNameArray addObject:ass.fileName];
            [weakSelf.imageSizeArray addObject:[NSString stringWithFormat:@"%f",ass.fileSize]];
            [weakSelf.imageUserNameArray addObject:[self getPhotoName]];
        }
        //改变photo所在的view以及显示选择的照片
        weakSelf.selectImageBlock(weakSelf.selectImageMubArray,weakSelf.imageFileNameArray,weakSelf.imageSizeArray,weakSelf.imageUserNameArray);
        //刷新界面
        [weakSelf.shareImageCollectionView reloadData];
    };
    pickerVc = nil;
}

#pragma mark - 拍照方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //获取image
    UIImage *selectImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    selectImage = [self fixOrientation:selectImage];
    NSData *imageData = UIImagePNGRepresentation(selectImage);
    NSInteger length = [imageData length]/1024;
    
    [self.selectImageMubArray addObject:selectImage];
    [self.imageFileNameArray addObject:[self getPhotoName]];
    [self.imageUserNameArray addObject:[self getPhotoName]];
    [self.imageSizeArray addObject:[NSString stringWithFormat:@"%ld",length]];
    
    //改变photo所在的view以及显示选择的照片
    self.selectImageBlock(self.selectImageMubArray,self.imageFileNameArray,self.imageSizeArray,self.imageUserNameArray);
    [self.shareImageCollectionView reloadData];
    
    if (self.dismissBlock) {
        self.dismissBlock(nil);
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    if (self.dismissBlock) {
        self.dismissBlock(nil);
    }
}

#pragma mark - 以时间戳去命名拍照图片的名字
- (NSString *)getPhotoName {
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970] * 1000;  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%f", a]; //转为字符型
    NSString *phName = [self md5:timeString];
    phName = [NSString stringWithFormat:@"%@.png",phName];
    return phName;
}
-(NSString *)md5:(NSString *)inPutText {
    
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
#pragma mark - 图片压缩
- (NSData *)compressImage:(UIImage *)image {
    
    NSUInteger maxFileSize = FILE_MAXSIZE;
    NSData *originImageData = UIImagePNGRepresentation(image);
    NSInteger length = [originImageData length]/1024;
    if (length < maxFileSize) {
        return originImageData;
    } else {
        CGFloat compressionRatio = 0.7f;
        CGFloat maxCompressionRatio = 0.1f;
        NSData *imageData = UIImageJPEGRepresentation(image, compressionRatio);
        
        while (imageData.length > maxFileSize && compressionRatio > maxCompressionRatio) {
            compressionRatio -= 0.1f;
            imageData = UIImageJPEGRepresentation(image, compressionRatio);
        }
        return imageData;
    }
}
#pragma mark - 旋转90度
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp) return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark - setMethod
- (void)setPhotoMaxCount:(NSInteger)photoMaxCount {
    _photoMaxCount = photoMaxCount;
}

- (void)setShowFlatAlertView:(BOOL *)showFlatAlertView {
    _showFlatAlertView = showFlatAlertView;
}

@end
