//
//  AddAddressManager.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/20.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "AddAddressManager.h"

#define dbPath ([DOCUMENT_FOLDER stringByAppendingPathComponent:@"Address.db"])

#define DBName    @"Address.db"
#define ADDRESSID        @"addressId"
#define CONTACTNAME      @"contactName"
#define TELNUM      @"telNum"
#define AREA   @"area"
#define DETAILADDRESS @"detailAddress"
#define ZIPCODE @"zipCode"
#define TABLENAME @"AddressTable"

static AddAddressManager *sharedInstance;

@implementation AddAddressManager

#pragma mark - 单例

+ (AddAddressManager *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 创建数据库

- (instancetype)init {
    
    if (self = [super init]) {
        
        //1.获得数据库文件的路径
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName=[doc stringByAppendingPathComponent:DBName];
        
        //2.获得数据库
        _database =[FMDatabase databaseWithPath:fileName];
        
        //3.打开数据库
        if ([_database open]) {
            //4.创地址表
            NSString *creatAddressTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' VARCHAR NOT NULL, '%@' VARCHAR NOT NULL, '%@' VARCHAR NOT NULL, '%@' VARCHAR NOT NULL, '%@' VARCHAR NOT NULL)",TABLENAME,ADDRESSID,CONTACTNAME,TELNUM,AREA,DETAILADDRESS,ZIPCODE];
            BOOL result=[_database executeUpdate:creatAddressTable];
            if (result) {
                NSLog(@"创地址表成功");
            }
        }else{
            NSLog(@"打开数据库失败");
        }
    }
    return self;
}

#pragma mark - 打开数据库

- (void)openDataBase{
    
    //1.获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"Address.db"];
    //2.获得数据库
    _database = [FMDatabase databaseWithPath:fileName];
    
    //3.打开数据库
    if ([_database open]) {
        //4.创地址表
        NSString *creatAddressTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' VARCHAR NOT NULL, '%@' VARCHAR NOT NULL, '%@' VARCHAR NOT NULL, '%@' VARCHAR NOT NULL, '%@' VARCHAR NOT NULL)",TABLENAME,ADDRESSID,CONTACTNAME,TELNUM,AREA,DETAILADDRESS,ZIPCODE];
        BOOL result = [_database executeUpdate:creatAddressTable];
        if (result) {
            NSLog(@"创地址表成功");
        }
    }else{
        NSLog(@"打开数据库失败");
    }
}

#pragma mark - 插入，保存数据

- (void)saveAddressInfoWithModel: (AddressModel *)model {
    
    NSString *sqlite = [NSString string];
    NSString *selectStr;
    sqlite = [NSString stringWithFormat:@"INSERT INTO '%@'('%@', '%@', '%@', '%@', '%@') VALUES(?,?,?,?,?)",TABLENAME, CONTACTNAME, TELNUM, AREA, DETAILADDRESS, ZIPCODE];
    selectStr = [NSString stringWithFormat:@"SELECT * FROM AddressTable"];
    FMResultSet *resultSet = [_database executeQuery:selectStr];
    while ([resultSet next]) {
//        NSString *IDString = [resultSet stringForColumn:@"addressId"];
//        if ([IDString isEqualToString:Id]) {
//            // 更新
//            NSString *updateSql = [NSString stringWithFormat:
//                                   @"UPDATE '%@' SET contactName = '%@' and  telNum = '%@' and area = '%@' and detailAddress = '%@' and zipCode = '%@' WHERE id = '%@'",
//                                   @"AddressTable",name, telNum ,area, detailAddress, zipCode, Id];
//            BOOL res = [self.database executeUpdate:updateSql];
//            if (!res) {
//                NSLog(@"error when update db table");
//            } else {
//                NSLog(@"success to update db table");
//            }
//        }
//        return;
    }
    //如果没有,将数据写进表里
    if ([_database executeUpdate:sqlite, model.contactName, model.telNum, model.area, model.detailAddress,model.zipCode]) {
        NSLog(@"存储数据成功");
    } else {
        NSLog(@"存储数据失败");
    }
}

#pragma mark - 读取所有人员列表

- (NSArray *)readAllAddressList  {
    
    NSString *queryPreparedString;
    queryPreparedString = @"SELECT * FROM AddressTable";
    FMResultSet *resultSet = [_database executeQuery:queryPreparedString];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    while ([resultSet next]) {
        AddressModel *model = [[AddressModel alloc] init];
        model.addressId = [resultSet stringForColumn:ADDRESSID];
        model.contactName = [resultSet stringForColumn:CONTACTNAME];
        model.telNum = [resultSet stringForColumn:TELNUM];
        model.area = [resultSet stringForColumn:AREA];
        model.detailAddress = [resultSet stringForColumn:DETAILADDRESS];
        model.zipCode = [resultSet stringForColumn:ZIPCODE];
        [array addObject:model];
    }
    return array.copy;
}

#if 0

- (void)updateAddressInfoWithId: (NSString *)Id contactName: (NSString *)name tel: (NSString *)telNum area: (NSString *)area detailAddress: (NSString *)detailAddress zipCode: (NSString *)zipCode {
    
    if ([self.database open]) {
        NSString *updateSql = [NSString stringWithFormat:
                               @"UPDATE '%@' SET '%@' = '%@' and  '%@' = '%@' and '%@' = '%@' and '%@' = '%@' and '%@' = '%@' WHERE '%@' = '%@'", TABLENAME,CONTACTNAME, name, telNum, telNum ,area, detailAddress, zipCode, Id];
        BOOL res = [self.database executeUpdate:updateSql];
        if (!res) {
            NSLog(@"error when update db table");
        } else {
            NSLog(@"success to update db table");
        }
    } else {
        NSLog(@"数据库没有打开");
    }
}

#endif

- (void)updateAddressInfoWithModel: (AddressModel *)model {
    if ([self.database open]) {
        NSString *updateSql = [NSString stringWithFormat:
                               @"UPDATE %@ SET %@ = '%@',  %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@' WHERE %@ = %ld", TABLENAME, CONTACTNAME, model.contactName, TELNUM, model.telNum ,AREA, model.area, DETAILADDRESS, model.detailAddress, ZIPCODE, model.zipCode, ADDRESSID, (long)[model.addressId integerValue]];
        BOOL res = [self.database executeUpdate:updateSql];
        if (!res) {
            NSLog(@"error when update db table");
        } else {
            NSLog(@"success to update db table");
        }
    } else {
        NSLog(@"数据库没有打开");
    }
}

- (void)deleteAddressInfoWithModel: (AddressModel *)model {
    
    if ([self.database open]) {
        FMResultSet *resultSet = [_database executeQuery:@"SELECT * FROM AddressTable"];
        while ([resultSet next]) {
            if ([model.addressId isEqualToString:[resultSet stringForColumn:ADDRESSID]]) {
                NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",TABLENAME, ADDRESSID];
                if ([self.database executeUpdate:sql,model.addressId]) {
                    [CombancHUD showSuccessWithStatus:@"删除成功"];
                }
            }
        }
    }
}

#pragma mark - 打开数据库

- (void)openDatabase {
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [docPath stringByAppendingPathComponent:DBName];
    //NSLog(@"fileName------------%@",fileName);
    _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:fileName];
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        
        //4.创地址表
        NSString *creatAddressTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS AddressTable (addressId INTEGER PRIMARY KEY AUTOINCREMENT, contactName VARCHAR NOT NULL, telNum VARCHAR NOT NULL, area VARCHAR NOT NULL, detailAddress VARCHAR NOT NULL, zipCode VARCHAR NOT NULL);"];
        BOOL result = [_database executeUpdate:creatAddressTable];
        if (result) {
            NSLog(@"创地址表成功");
        } else {
            NSLog(@"创地址表失败");
        }
    }];
}

#pragma mark - 关闭数据库

- (void)closeDatabase {
    
    [_database close];
}

@end
