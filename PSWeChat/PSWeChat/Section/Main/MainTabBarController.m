//
//  MainTabBarController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/14.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBar];
}

- (void)setTabBar {
    
    NSArray *normalImage = @[@"tabbar_mainframe", @"tabbar_contacts",@"tabbar_discover", @"tabbar_me"];
    NSArray *selectImage = @[@"tabbar_mainframeHL", @"tabbar_contactsHL",@"tabbar_discoverHL", @"tabbar_meHL"];
    NSArray *vcClass = @[@"HomeViewController", @"ContractViewController", @"FindViewController", @"MeViewController"];
    NSArray *titleArray = @[@"微信",@"通讯录",@"发现", @"我的"];
    NSMutableArray *allArray = [NSMutableArray array];
    
    for (int i = 0; i < normalImage.count; i++) {
        Class cla = NSClassFromString(vcClass[i]);
        UIViewController *vc = [[cla alloc] init];
        vc.title = titleArray[i];
        vc.navigationItem.title = titleArray[i];
        [vc.tabBarItem setTitle:titleArray[i]];
        [vc.tabBarItem setImage:[[UIImage imageNamed:normalImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [vc.tabBarItem setSelectedImage:[[UIImage imageNamed:selectImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [allArray addObject:nav];
    }
    //设置navigationBar样式
//    [self setUpNavigationBarAppearance];
    //tabBarItem 的选中和不选中文字属性
    [self setUpTabBarItemTextAttributes];
    // 这句必须写!
    self.viewControllers = allArray;
}

/**
 *  设置navigationBar样式
 */
- (void)setUpNavigationBarAppearance {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"navigationBar_BG"];
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName: [UIColor darkGrayColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationBar_BG"];
        
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor: [UIColor blackColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

/**
 *  tabBarItem 的选中和不选中文字属性
 */
- (void)setUpTabBarItemTextAttributes {
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:9 / 255.0 green:187 / 255.0 blue:7 / 255.0 alpha:1];;
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // 设置背景图片
    //    UITabBar *tabBarAppearance = [UITabBar appearance];
    //    [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbarBG"]];
    //    tabBarAppearance.barTintColor = MAIN_COLOR;
}

@end
