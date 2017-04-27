//
//  LocationViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/26.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "LocationViewController.h"
#import <BaiduMapKit/BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKPoiSearch.h>

@interface LocationViewController ()<BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKMapViewDelegate>

@property (nonatomic,strong) BMKLocationService *service;//定位服务
@property (nonatomic,strong) BMKPoiSearch *poiSearch;//搜索服务
@property (nonatomic, strong) NSMutableArray *locationDataArray;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"所在位置";
    [self getLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.service.delegate = nil;
    self.poiSearch.delegate = nil;
}

- (void)getLocation {
    //初始化定位
    self.service = [[BMKLocationService alloc] init];
    //设置代理
    self.service.delegate = self;
    //开启定位
    [self.service startUserLocationService];
}

#pragma mark - BMKLocationServiceDelegate

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //初始化搜索
    self.poiSearch =[[BMKPoiSearch alloc] init];
    self.poiSearch.delegate = self;
    //初始化一个周边云检索对象
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc] init];
    //索引 默认为0
    option.pageIndex = 0;
    //页数默认为10
    option.pageCapacity = 50;
    //搜索半径
    option.radius = 200;
    //检索的中心点，经纬度
    option.location = userLocation.location.coordinate;
    //搜索的关键字 关键词必须写,否则失败.http://bbs.lbsyun.baidu.com/forum.php?mod=viewthread&tid=80683
    option.keyword = @"位置"; 
    //根据中心点、半径和检索词发起周边检索
    BOOL flag = [self.poiSearch poiSearchNearBy:option];
    if (flag) {
        NSLog(@"搜索成功");
        //关闭定位
        [self.service stopUserLocationService];
    } else {
        NSLog(@"搜索失败");
    }
}

#pragma mark -------BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    
    //若搜索成功
    if (errorCode ==BMK_SEARCH_NO_ERROR) {
        //POI信息类
        //poi列表
        for (BMKPoiInfo *info in poiResult.poiInfoList) {
            [self.locationDataArray addObject:info];
        }
    } else if (errorCode == BMK_SEARCH_RESULT_NOT_FOUND) {
        [CombancHUD showInfoWithStatus:@"没有找到检索内容哟"];
    }
}

/**
 *返回POI详情搜索结果
 *@param searcher 搜索对象
 *@param poiDetailResult 详情搜索结果
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode {
    
    NSLog(@"%@",poiDetailResult.name);
    
}

#pragma mark - 懒加载

- (NSMutableArray *)locationDataArray {
    
    if (!_locationDataArray) {
        _locationDataArray = [NSMutableArray array];
    }
    return _locationDataArray;
}

@end
