//
//  AddAddressManager.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/20.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "AddressModel.h"

@interface AddAddressManager : NSObject

@property (strong, nonatomic) FMDatabase *database;
@property (strong, nonatomic) FMDatabaseQueue *databaseQueue;

/**
 *  单例
 */
+ (AddAddressManager *)shareInstance;

/* 存储地址列表
- (void)saveAddressInfoWithId: (NSString *)Id contactName: (NSString *)name tel: (NSString *)telNum area: (NSString *)area detailAddress: (NSString *)detailAddress zipCode: (NSString *)zipCode;

- (void)updateAddressInfoWithId: (NSString *)Id contactName: (NSString *)name tel: (NSString *)telNum area: (NSString *)area detailAddress: (NSString *)detailAddress zipCode: (NSString *)zipCode;
*/

/**
  更新地址表

 @param model 更新的model
 */
- (void)updateAddressInfoWithModel: (AddressModel *)model;

/**
 保存,插入地址表

 @param model 需要插入的model
 */
- (void)saveAddressInfoWithModel: (AddressModel *)model;

/**
 读取所有地址列表

 @return 所有model数组数据
 */
- (NSArray *)readAllAddressList;

/**
 删除model数据

 @param model 要删除的model
 */
- (void)deleteAddressInfoWithModel: (AddressModel *)model;

/**
 *  打开数据库
 */
- (void)openDatabase;

/**
 *  关闭数据库
 */
- (void)closeDatabase;


@end
