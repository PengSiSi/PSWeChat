//
//  WSelectPhotoPickerViewController.m
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/21.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#import "WSelectPhotoPickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "WSelectPhotoNavigationViewController.h"
#import "WSelectPhotoPickerGroupViewController.h"
#import "WSelectPhotoCommon.h"
#import "WSelectPhotoAssets.h"

@interface WSelectPhotoPickerViewController ()
@property (nonatomic , weak) WSelectPhotoPickerGroupViewController *groupVc;
@end

@implementation WSelectPhotoPickerViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNotification];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init Action
- (void) createNavigationController{
    WSelectPhotoPickerGroupViewController *groupVc = [[WSelectPhotoPickerGroupViewController alloc] init];
    WSelectPhotoNavigationViewController *nav = [[WSelectPhotoNavigationViewController alloc] initWithRootViewController:groupVc];
    nav.view.frame = self.view.bounds;
    [self addChildViewController:nav];
    [self.view addSubview:nav.view];
    self.groupVc = groupVc;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self createNavigationController];
    }
    return self;
}

- (void)setSelectPickers:(NSArray *)selectPickers{
    _selectPickers = selectPickers;
    self.groupVc.selectAsstes = selectPickers;
}

- (void)setStatus:(PickerViewShowStatus)status{
    _status = status;
    self.groupVc.status = status;
}

- (void)setMinCount:(NSInteger)minCount{
    if (minCount <= 0) return;
    _minCount = minCount;
    self.groupVc.minCount = minCount;
}

#pragma mark - 展示控制器
- (void)show{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[[[UIApplication sharedApplication].windows lastObject] rootViewController] presentViewController:self animated:YES completion:nil];
}

- (void) addNotification{
    // 监听异步done通知
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(done:) name:PICKER_TAKE_DONE object:nil];
    });
}

- (void) done:(NSNotification *)note{
    
    NSArray *selectArray =  note.userInfo[@"selectAssets"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(pickerViewControllerDoneAsstes:)]) {
            [self.delegate pickerViewControllerDoneAsstes:selectArray];
        }else if (self.callBack){
            
            self.callBack(selectArray);
            
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)setDelegate:(id<WPhotoPickerViewControllerDelegate>)delegate{
    _delegate = delegate;
    self.groupVc.delegate = delegate;
}

#pragma mark - 通过传入一个图片对象（WSelectPhotoAssets/ALAsset）获取一张缩略图
+ (UIImage *) getImageWithImageObj:(id)imageObj{
    __block UIImage *image = nil;
    if ([imageObj isKindOfClass:[UIImage class]]) {
        return imageObj;
    }else if ([imageObj isKindOfClass:[ALAsset class]]){
        ALAsset *asset = (ALAsset *)imageObj;
        return [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
    }else if ([imageObj isKindOfClass:[WSelectPhotoAssets class]]){
        
        return [imageObj thumbImage];
    }
    return image;
}

@end
