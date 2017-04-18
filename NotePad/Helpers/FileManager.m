//
//  FileManager.m
//  NotePad
//
//  Created by 陈晓磊 on 17/2/28.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

// 获取应用沙盒根路径
+ (void)dirHome
{
//    NSString *dirHome = NSHomeDirectory();
}
// 获取Dircuments目录
+ (NSString *)dirDoc
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dirDoc = [paths objectAtIndex:0];
    
    return dirDoc;
}
// 获取Library目录
+ (NSString *)dirLib
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *dirLib = [paths objectAtIndex:0];
    
    return dirLib;
}
// 获取Library/Cache目录
+ (NSString *)dirLibCache
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *dirLibCache = [paths objectAtIndex:0];
    
    return dirLibCache;
}
// 获取Temp目录
+ (void)dirTemp
{
//    NSString *dirTemp = NSTemporaryDirectory();
}
// 创建新文件夹
+ (BOOL)createDir:(NSString *)path
{
    NSString *dirDoc = [self dirDoc];
    NSString *newDir = [dirDoc stringByAppendingPathComponent:path];
    
    BOOL res = [[NSFileManager defaultManager] createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error:nil];
   
    return res;
}

// 写文件
+ (BOOL)writeFile:(NSString *)path content:(NSString *)content
{
    BOOL res = [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];

    return res;
}

// 读文件
+ (NSString *)readFile:(NSString *)path
{
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return content;
}

// 获取文件属性
+ (void)fileAttributes:(NSString *)path fileName:(NSString *)fileName
{
    NSString *dirDoc = [self dirDoc];
    NSString *testDir = [dirDoc stringByAppendingPathComponent:path];
    NSString *testPath = [testDir stringByAppendingPathComponent:fileName];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:testPath error:nil];
    
    NSArray *keys;
    id key, value;
    keys = [fileAttributes allKeys];
    NSInteger count = [keys count];
    for (int i = 0; i < count; i ++) {
        key = [keys objectAtIndex:i];
        value = [fileAttributes objectForKey:key];
        ZLog(@"Key:%@ for value:%@", key, value);
    }
}

// 删除文件
+ (void)deleteFile:(NSString *)path
{
   [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

// 判断文件是否存在
+ (BOOL)isExitsFile:(NSString *)path
{
    BOOL res = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return res;
}

// 追加文本内容，使用NSFileHandler
+ (void)updateFile:(NSString *)path newContent:(NSString *)content
{
    //追加文本而不是覆盖
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path];
    [fileHandle seekToEndOfFile];
    
    [fileHandle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
}
@end
