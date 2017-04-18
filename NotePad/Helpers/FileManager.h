//
//  FileManager.h
//  NotePad
//
//  Created by 陈晓磊 on 17/2/28.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

// 获取应用沙盒根路径
+ (void)dirHome;
// 获取Dircuments目录
+ (NSString *)dirDoc;
// 获取Library目录
+ (NSString *)dirLib;
// 获取Library/Cache目录
+ (NSString *)dirLibCache;
// 获取Temp目录
+ (void)dirTemp;
// 创建新文件夹
+ (BOOL)createDir:(NSString *)path;
// 写文件
+ (BOOL)writeFile:(NSString *)path content:(NSString *)content;
// 读文件
+ (NSString *)readFile:(NSString *)path;
// 获取文件属性
+ (void)fileAttributes:(NSString *)path fileName:(NSString *)fileName;
// 删除文件
+ (void)deleteFile:(NSString *)path;
// 判断文件是否存在
+ (BOOL)isExitsFile:(NSString *)path;
// 追加文本内容，使用NSFileHandler
+ (void)updateFile:(NSString *)path newContent:(NSString *)content;

@end
