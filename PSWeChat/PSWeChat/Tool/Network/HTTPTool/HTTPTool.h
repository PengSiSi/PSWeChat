//
//  HTTPTool.h
//  TestContact
//
//  Created by AlicePan on 16/9/18.
//  Copyright © 2016年 AlicePan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 *  请求成功后的回调
 *
 *  @param json 服务器返回的JSON数据
 */
typedef void (^HttpSuccess)(id json);
/**
 *  请求失败后的回调
 *
 *  @param error 错误信息
 */
typedef void (^HttpFailure)(NSError *error);

typedef void (^DownloadSight)(NSURLResponse *response, NSURL *filePath, NSError *error);

@interface HTTPTool : NSObject

@property (assign, nonatomic) BOOL showDownloadLoading;/**< 默认是YES*/


/**
 *  发送一POST请求
 *
 *  @param url     请求路径
 *  @param headers 请求headers参数
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url headers:(NSDictionary *)headers params:(NSDictionary *)params success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 *  发送一GET请求
 *
 *  @param url     请求路径
 *  @param headers 请求headers参数
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url headers:(NSDictionary *)headers params:(NSDictionary *)params success:(HttpSuccess)success failure:(HttpFailure)failure;


+ (void)soapWithMethod:(NSString *)method param:(NSString *)params success:(HttpSuccess)success failure:(HttpFailure)failure;

+ (void)postXMLWithURL:(NSString *)url headers:(NSDictionary *)headers params:(NSDictionary *)params success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 *  上传图片
 *
 *  @param url          请求路径
 *  @param params       请求参数
 *  @param image        上传的图片
 *  @param imageName    上传的图片名
 *  @param success      请求成功后的回调
 *  @param failure      请求失败后的回调
 */
+ (void)upLoadWithURL:(NSString *)url param:(NSDictionary *)params image:(UIImage *)image imageName:(NSString *)imageName success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 *  上传多张图片
 *
 *  @param url          请求路径
 *  @param params       请求参数
 *  @param imageDicArray     上传的图片字典 包含图片和图片名 {@"imageName":@"name.png",@"image":@"UIImage"}
 *  @param success      请求成功后的回调
 *  @param failure      请求失败后的回调
 */
+ (void)upLoadMutiWithURL:(NSString *)url param:(NSDictionary *)params imageDicArray:(NSArray *)imageDicArray success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 *  下载文件
 *
 *  @param url     文件路径
 *  @param name 文件保存的名称
 *  @param path 文件的Document下的哪个文件夹下
 */
+ (void)downLoadWithUrl:(NSString *)url withName:(NSString *)name withFilePath:(NSString *)path;

/**
 *  下载文件
 *
 *  @param url     文件路径
 *  @param fileName 文件保存的名称
 *  @param customFilePath 文件的Document下的哪个文件夹下
 */
+ (void)downLoadSightWithUrl:(NSString *)url fileName:(NSString *)fileName customFilePath:(NSString *)customFilePath downloadSight:(DownloadSight)downloadSight;

@end

@interface AFHTTPSessionManager (SOAP)

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                  soapStringData:(NSData *)soapStringData
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end
