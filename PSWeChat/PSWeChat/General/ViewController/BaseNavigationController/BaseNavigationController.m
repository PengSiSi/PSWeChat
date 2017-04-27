//
//  BaseNavigationController.m
//  PSWeather
//
//  Created by 思 彭 on 16/11/16.
//  Copyright © 2016年 思 彭. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIBarButtonItem+Create.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.tintColor = [UIColor whiteColor];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [navBar setShadowImage:[UIImage new]];
    navBar.translucent = NO;
//
    //设置NavigationBar背景颜色
    [[UINavigationBar appearance] setBarTintColor:kNavBarBgColor];
    //不设置这个无法修改状态栏字体颜色
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 添加返回按钮
//        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"leftNavBack"] highLightedImage:[UIImage imageNamed:@"leftNavBack"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

@end
