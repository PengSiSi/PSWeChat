//
//  AppDelegate.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/14.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+JKRRootViewController.h"
#import <IQKeyboardManager.h>
#import "AddAddressManager.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#define BAIDU_MAP_KEY (@"7aLAR28zg0jqAc0OzTlbzgozUT0ILms3")

@interface AppDelegate ()
{
    BMKMapManager* _mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BAIDU_MAP_KEY  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    // 配置AppDelegate
    [self configureRootViewController];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
    
    // 打开地址保存数据库
    [[AddAddressManager shareInstance]openDatabase];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
