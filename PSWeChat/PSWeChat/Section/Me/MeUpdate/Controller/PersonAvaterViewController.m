//
//  PersonAvaterViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/19.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "PersonAvaterViewController.h"

@interface PersonAvaterViewController ()

@property (nonatomic, strong) UIImageView *avaterImgView;
@property (nonatomic, strong) UIImage *defaultImage;

@end

@implementation PersonAvaterViewController

- (instancetype)initWithPersonAvaterViewControllerWithDefaultAvaterImage: (UIImage *)defaultAvaterImage {
    if (self = [super init]) {
        _defaultImage = defaultAvaterImage;
    }
    return self;
}

+ (instancetype)PersonAvaterViewControllerage: (UIImage *)defaultAvaterImage {
    
    return [[self alloc]initWithPersonAvaterViewControllerWithDefaultAvaterImage:defaultAvaterImage];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupUI];
    [self setNavItem];
}

#pragma mark -  设置界面

- (void)setupUI{
    
    self.avaterImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, (K_SCREEN_HEIGHT - 400) / 2, K_SCREEN_WIDTH - 40, 400)];
    self.avaterImgView.image = self.defaultImage;
    [self.view addSubview:self.avaterImgView];
}

- (void)setNavItem{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"..." style:UIBarButtonItemStylePlain target:self action:@selector(updateAvaterAction:)];
}

#pragma mark - Private Method

- (void)updateAvaterAction: (UIBarButtonItem *)item {
    
}


@end
