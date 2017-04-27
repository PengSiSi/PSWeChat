//
//  CollectViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/23.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "CollectViewController.h"
#import "AddCollectViewController.h"

@interface CollectViewController ()

@end

@implementation CollectViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
}

# pragma mark - 设置界面

- (void)setNavItem {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCollect)];
}

#pragma mark - Private Method

- (void)addCollect {
 
    AddCollectViewController *addCollectVc = [[AddCollectViewController alloc]init];
    [self.navigationController pushViewController:addCollectVc animated:YES];
}

@end
