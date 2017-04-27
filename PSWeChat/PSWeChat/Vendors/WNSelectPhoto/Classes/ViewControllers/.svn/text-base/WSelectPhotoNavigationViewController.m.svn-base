//
//  WSelectPhotoNavigationViewController.m
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/21.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#import "WSelectPhotoNavigationViewController.h"
#import "WSelectPhotoCommon.h"
@implementation WSelectPhotoNavigationViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UINavigationController *rootVc = (UINavigationController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    
    if ([rootVc isKindOfClass:[UINavigationController class]]) {
        [self.navigationBar setValue:[rootVc.navigationBar valueForKeyPath:@"barTintColor"] forKeyPath:@"barTintColor"];
        [self.navigationBar setTintColor:rootVc.navigationBar.tintColor];
        [self.navigationBar setTitleTextAttributes:rootVc.navigationBar.titleTextAttributes];
        
    }else{
        [self.navigationBar setValue:DefaultNavbarTintColor forKeyPath:@"barTintColor"];
        [self.navigationBar setTintColor:DefaultNavTintColor];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:DefaultNavTitleColor}];
    }
}
@end
