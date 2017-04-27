//
//  FileManager.h
//  Donghuamen
//
//  Created by AlicePan on 16/10/10.
//  Copyright © 2016年 Combanc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DeleteCompletion)();

@interface FileManager : NSObject

@property (copy, nonatomic) DeleteCompletion deleteCompletion;/**< 删除完成block*/

+ (FileManager *)sharedInstance;

// 获取应用下各个文件夹大小及图片缓存大小
+ (float)getFileSizeWithImageCasheSize;

// 获取文件夹下文件大小
+ (float)fileSizeForDirectory:(NSString*)path;

//获取文件路径下的文件大小
+ (float)fileSizeAtPath:(NSString *)path;


// 删除文件夹路径下的文件
- (void)deleteFileWithPath:(NSString *)path;

// 删除文件并且删除图片缓存
- (void)deleteFileWithImageCashe:(DeleteCompletion)completion;

/**
 *  创建文件夹
 *
 *  @param filePath 文件的Document下的哪个文件夹下
 */
- (void)createFilePath:(NSString *)filePath;

/**
 *  判断文件是否存在
 *
 *  @param path 文件的Document下的哪个文件夹下
 *  @param name 文件保存的名称
 */
- (BOOL)fileExitWithPath:(NSString *)path name:(NSString *)name;

/**
 *  判断文件夹是否存在
 *
 *  @param path 文件的Document下的哪个文件夹下
 */
- (BOOL)filePathExitWithFilePath:(NSString *)path;

/**
 *  通过文件名获取全路径
 *
 *  @param fileName 文件的Document下的文件名
 */
- (NSString *)getFileFullPathWithName:(NSString *)fileName;


/**
 *  通过文件名和文件夹获取全路径
 *
 *  @param fileName 文件的Document下的文件名
 *  @param filePath 文件的文件夹
 */
- (NSString *)getFileFullPathWithName:(NSString *)fileName filePath:(NSString *)filePath;

@end
