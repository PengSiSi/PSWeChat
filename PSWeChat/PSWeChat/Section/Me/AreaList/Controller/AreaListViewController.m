//
//  AreaListViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/24.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "AreaListViewController.h"
#import "JsonDataService.h"
#import "AreaListModel.h"
#import "LabelTableViewCell.h"
#import "AreaDetailViewController.h"
#import "JFLocation.h"
#import "LoacationCell.h"
#import <BaiduMapKit/BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

static NSString *const cellId = @"CellId";
static NSString *const labelCellId = @"LabelCellId";

@interface AreaListViewController ()<UITableViewDelegate, UITableViewDataSource,JFLocationDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKReverseGeoCodeOption *reverseGeoCodeOption; ;
@property (nonatomic, strong) BMKGeoCodeSearch *searcher;
@property (nonatomic, strong) BMKDistrictSearch *districtSearch;

@end

@implementation AreaListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self initial];
    [self readData];
    [self setUI];
    
    //启动LocationService
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    [_locService setDesiredAccuracy:kCLLocationAccuracyBest];//设置定位精度
    [self.locService startUserLocationService];
    //初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
}

//-(BMKLocationService *)localService{
//    if (!_locService) {
//        _locService = [[BMKLocationService alloc] init];
//        [_locService setDesiredAccuracy:kCLLocationAccuracyBest];//设置定位精度
//    }
//    return _locService;
//}

-(void)viewWillDisappear:(BOOL)animated {
    _searcher.delegate = nil;
    _locService.delegate = nil;
}

- (void)initial {
    
    JFLocation *loaction = [[JFLocation alloc]init];
    loaction.delegate = self;
}

- (void)readData {
    
    JsonDataService *jsonService = [[JsonDataService alloc]init];
    NSArray *areaListArray = [jsonService readPlistDataWithPath:@"area 2" jsonType:@"plist"];
//    NSLog(@"areaListArray = %@",areaListArray);
    self.dataArray = [AreaListModel mj_objectArrayWithKeyValuesArray:areaListArray];
}

#pragma mark - 设置界面

- (void)setUI {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    // 注册cell
    [self.tableView registerClass:[LoacationCell class] forCellReuseIdentifier:cellId];
    [self.tableView registerClass:[LabelTableViewCell class] forCellReuseIdentifier:labelCellId];
    [self.view addSubview: self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        LoacationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        [cell configureCellWithStartAnimation:self.locationName ? NO : YES locationName:self.locationName];
        return cell;
    } else {
        LabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:labelCellId forIndexPath:indexPath];
        AreaListModel *areaListModel = self.dataArray[indexPath.row];
        if (indexPath.row == 0) {
            [cell configureLeftLabelText:areaListModel.state rightLabeltext:@"已选地区"];
        } else {
            [cell configureLeftLabelText:areaListModel.state rightLabeltext:@""];
        }
        if (areaListModel.cities.count > 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? @"定位到的位置" : @"全部";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        AreaListModel *areaListModel = self.dataArray[indexPath.row];
        if (indexPath.row == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            AreaDetailViewController *detailVc = [[AreaDetailViewController alloc]init];
            cityModel *model = areaListModel.cities[0];
            detailVc.areaArray = model.areas;
            [self.navigationController pushViewController:detailVc animated:YES];
        }
    }
}

#pragma mark - BMKLocationServiceDelegate

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    NSLog(@"heading is %@",userLocation.heading);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//    发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag) {
      NSLog(@"反geo检索发送成功");
        // 关闭定位
      [self.locService stopUserLocationService];
    } else
    {
      NSLog(@"反geo检索发送失败");
    }
}

#pragma mark - BMKGeoCodeSearchDelegate

//接收反向地理编码结果
- (void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      // 在此处理正常结果
      NSLog(@"result = %@--%@,",result.address,result.addressDetail);
      self.locationName = [NSString stringWithFormat:@"%@ %@",result.addressDetail.country, result.addressDetail.province];
      [self.tableView reloadData];
  } else {
      NSLog(@"抱歉，未找到结果");
  }
}

#if 0

#pragma mark - JFDelegate

/// 定位中
- (void)locating {
    
    NSLog(@"定位中");
}

/**
 当前位置
 
 @param locationDictionary 位置信息字典
 */
- (void)currentLocation:(NSDictionary *)locationDictionary {
    NSLog(@"%@",locationDictionary);
}

/**
 拒绝定位后回调的代理
 
 @param message 提示信息
 */
- (void)refuseToUsePositioningSystem:(NSString *)message {
    
    NSLog(@"%@",message);
}

/**
 定位失败回调的代理
 
 @param message 提示信息
 */
- (void)locateFailure:(NSString *)message {
    
    NSLog(@"%@",message);
}

#endif



@end
