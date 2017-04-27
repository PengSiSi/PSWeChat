//
//  FileManager.m
//  Donghuamen
//
//  Created by AlicePan on 16/10/10.
//  Copyright © 2016年 Combanc. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

static FileManager *manager = nil;
+ (FileManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FileManager alloc] init];
    });
    return manager;
}

+ (float)getFileSizeWithImageCasheSize {
    NSArray *filePathArray = @[K_NOTICE_PATH, K_WORK_PATH, K_VOTE_PATH, K_ACTIVITY_PATH, K_BOOK_PATH, K_ALBUM_PATH, K_RESOURCE_PATH, K_SHARE_PATH,K_APPENDIX_PATH];
    NSUInteger size = [[SDWebImageManager sharedManager].imageCache getSize];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    float fileSize;
    for (NSInteger i = 0; i< filePathArray.count; i++) {
        NSString *filePath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", filePathArray[i]]];
        float filePathSize = [self fileSizeForDirectory:filePath];
        fileSize += filePathSize;
    }
    float totalSize = fileSize/1024/1024 + size/1024.0/1024.0;
    return totalSize;
}

#pragma mark - 文件类
//计算文件夹下文件的总大小 递归方法计算
+ (float)fileSizeForDirectory:(NSString*)path {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float size = 0;
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    for(int i = 0; i<[array count]; i++) {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        //判断是不是文件夹
        BOOL isFolder = NO;
        //判断是不是存在路径 并且是不是文件夹
        BOOL isExist = [fileManager fileExistsAtPath:fullPath isDirectory:&isFolder];
        if (isExist) {
            if (isFolder) {
                size += [self fileSizeForDirectory:fullPath];
            } else {
                NSDictionary *fileAttributeDic = [fileManager attributesOfItemAtPath:fullPath error:nil];
                size += fileAttributeDic.fileSize;
            }
        }
    }
    return size;
}

//获取文件路径下的文件大小
+ (float)fileSizeAtPath:(NSString *)path {
    NSFileManager* manager =[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]){
        return [[manager attributesOfItemAtPath:path error:nil] fileSize];
    }
    return 0;
}

// 移除存储的文件
- (void)deleteFileWithPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [docPath stringByAppendingPathComponent:path];
    [fileManager removeItemAtPath:filePath error:nil];
}

- (void)deleteFileWithImageCashe:(DeleteCompletion)completion {
    NSArray *filePathArray = @[K_NOTICE_PATH, K_WORK_PATH, K_VOTE_PATH, K_ACTIVITY_PATH, K_BOOK_PATH, K_ALBUM_PATH, K_RESOURCE_PATH, K_SHARE_PATH];
    for (NSInteger i = 0; i< filePathArray.count; i++) {
        [self deleteFileWithPath:filePathArray[i]];
    }
    if (_deleteCompletion) {
        _deleteCompletion();
    }
    [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:^{
        if (_deleteCompletion) {
            _deleteCompletion();
        }
    }];
    _deleteCompletion = completion;
}

/**
 *  创建文件夹
 *
 *  @param filePath 文件的Document下的哪个文件夹下
 */
- (void)createFilePath:(NSString *)filePath {
    if ([self filePathExitWithFilePath:filePath]) {
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *aFilePath = [docPath stringByAppendingPathComponent:filePath];
    [fileManager createDirectoryAtPath:aFilePath withIntermediateDirectories:YES attributes:nil error:nil];
}

- (BOOL)fileExitWithPath:(NSString *)path name:(NSString *)name {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *aFilePath = [docPath stringByAppendingPathComponent:path];
    NSString *fileNamePath = [aFilePath stringByAppendingPathComponent:name];
    if ([fileManager fileExistsAtPath:aFilePath] && [fileManager fileExistsAtPath:fileNamePath]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)filePathExitWithFilePath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *aFilePath = [docPath stringByAppendingPathComponent:path];
    if ([fileManager fileExistsAtPath:aFilePath]) {
        return YES;
    } else {
        return NO;
    }
}

/**
 *  通过文件名和文件夹获取全路径
 *
 *  @param fileName 文件的Document下的文件名
 */
- (NSString *)getFileFullPathWithName:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask,
                                                        YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:fileName];
}

/**
 *  通过文件名和文件夹获取全路径
 *
 *  @param fileName 文件的Document下的文件名
 *  @param filePath 文件的文件夹
 */
- (NSString *)getFileFullPathWithName:(NSString *)fileName filePath:(NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", filePath, fileName]];
}

@end
