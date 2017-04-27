//
//  HomeSearchViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/18.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "HomeSearchViewController.h"

@interface HomeSearchViewController ()

@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) NSMutableArray *dataMutableArray;

@end

@implementation HomeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialData];
    [self setupUI];
}

- (void)initialData {
    
    self.dataMutableArray = [[NSMutableArray alloc]init];
}

- (void)setupUI {

    self.tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [self.tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tabelView.showsVerticalScrollIndicator = NO;
    self.tabelView.bouncesZoom = NO;
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    self.tabelView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tabelView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = @"思思";
    return cell;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"Entering:%@ ",searchController.searchBar.text);
}
    
@end
