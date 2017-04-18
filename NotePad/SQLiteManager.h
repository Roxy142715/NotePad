//
//  SQLiteManager.h
//  NotePad
//
//  Created by 陈晓磊 on 17/3/13.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiteManager : NSObject

+ (instancetype)sharedManager;

// 打开数据库
- (void)openDataBaseWithName:(NSString *)dbName;

// 执行无返回的sql语句
- (void)executeNonQuery:(NSString *)sql;

// 执行有返回的sql
- (NSMutableArray *)executeQuery:(NSString *)sql;

// 增删改查
- (void)insertData:(NSDictionary<NSString *, id>*)dataDic intoTable:(NSString *)tName;

- (void)deleteDataFromTable:(NSString *)tName whereString:(NSString *)wlStr;

- (void)updateTable:(NSString *)tName setState:(NSString *)state whereString:(NSString *)wlStr;

@end
