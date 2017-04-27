//
//  AddTextAndPhotoView.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/19.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "AddTextAndPhotoView.h"
#import "ContentTextView.h"
#import "SelectPhotoView.h"
#import "UIView+CurrentViewController.h"
#import "MWPhotoBrowser.h"

#define IMAGE_SPACE (10) // 图片间距
#define IMAGE_COLUMN_NUM (4) // 图片列数
#define IMAGE_WIDTH (K_SCREEN_WIDTH - 20 - (IMAGE_COLUMN_NUM+1)*IMAGE_SPACE)/IMAGE_COLUMN_NUM // 每张图片宽度
#define SIGHT_WIDTH (160) // 小视频宽度

@interface AddTextAndPhotoView ()<UITextViewDelegate>

@property (nonatomic, strong) ContentTextView *textView;
@property (nonatomic, strong) SelectPhotoView *selectPhotoView;
@property (strong, nonatomic) NSMutableArray *selectImageArray;
@property (strong, nonatomic) NSMutableArray *fileNameArray;
@property (strong, nonatomic) NSMutableArray *useNameArray;
@end

@implementation AddTextAndPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.textView = [[ContentTextView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH - 20, 100)];
    self.textView.delegate = self;
    self.textView.placeholder = @"这一刻的想法...";
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.font = FONT_16;
    self.textView.placeholderColor = PLACEHOLDER_COLOR;
    [self addSubview:self.textView];
    
    self.selectPhotoView = [[SelectPhotoView alloc] initWithItemSize:CGSizeMake(IMAGE_WIDTH, IMAGE_WIDTH) placeholderImage:@[[UIImage imageNamed:@"AlbumAddBtn"]].mutableCopy selectPhotoMaxCount:9 passImageArray:[self.passImageArray mutableCopy] spaceOfline:IMAGE_SPACE];
    [self addSubview:self.selectPhotoView];
    self.selectPhotoView.frame = CGRectMake(0, self.textView.bottom, CGRectGetWidth(self.textView.frame) , 100);
    __weak typeof(self) weakSelf = self;
    [self.selectPhotoView setPresentBlock:^(id presentVC) {
        if ([presentVC isKindOfClass:[MWPhotoBrowser class]]) {
            weakSelf.getCurrentViewController.navigationController.navigationBar.titleTextAttributes = @{
                                                                                                         NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                                                                                         NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                         };
            [weakSelf.getCurrentViewController.navigationController pushViewController:presentVC animated:YES];
        }else {
            [weakSelf.getCurrentViewController.navigationController presentViewController:presentVC animated:YES completion:nil];
        }
    }];
    
    [self.selectPhotoView setDismissBlock:^(id dismissVC) {
        if ([dismissVC isKindOfClass:[MWPhotoBrowser class]]) {
            weakSelf.getCurrentViewController.navigationController.navigationBar.titleTextAttributes = @{
                                                                                                         NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                                                                                         NSForegroundColorAttributeName: [UIColor blackColor],
                                                                                                         };
            [weakSelf.getCurrentViewController.navigationController popViewControllerAnimated:YES];
        }else {
            [weakSelf.getCurrentViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [self.selectPhotoView setSelectImageBlock:^(NSMutableArray *imageArray, NSMutableArray *fileNameArray, NSMutableArray *sizeArray, NSMutableArray *userNameArray) {
        if (weakSelf.selectImageArray.count > 0) {
            [weakSelf.selectImageArray removeAllObjects];
        }
        if (weakSelf.fileNameArray.count > 0) {
            [weakSelf.fileNameArray removeAllObjects];
        }
        if (weakSelf.useNameArray.count > 0) {
            [weakSelf.useNameArray removeAllObjects];
        }
        [weakSelf.selectImageArray addObjectsFromArray:imageArray];
        [weakSelf.fileNameArray addObjectsFromArray:fileNameArray];
        [weakSelf.useNameArray addObjectsFromArray:userNameArray];
        
        [weakSelf changeHeaderViewFrame];
        
        // 选好图片的回调
        if (weakSelf.selectedImageBlock) {
            weakSelf.selectedImageBlock(imageArray,fileNameArray, sizeArray,userNameArray);
        }
    }];
}

- (void)changeHeaderViewFrame {
    NSInteger row = 0;
    if (_selectImageArray.count + 1 < 5) {
        row = 1;
    } else if (_selectImageArray.count + 1 > 4 && _selectImageArray.count + 1 < 9) {
        row = 2;
    } else {
        row = 3;
    }
    self.selectPhotoView.frame = CGRectMake(0, self.textView.bottom, self.textView.width, CGRectGetHeight(self.textView.frame) + IMAGE_WIDTH * row + 10 * row +1);
    
    // 通知改变头视图的高度
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateShareAddHeaderViewHeight" object:nil userInfo:@{@"headerViewHeight" : @(self.selectPhotoView.height + 100)}];
}

#pragma mark - TextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

@end
