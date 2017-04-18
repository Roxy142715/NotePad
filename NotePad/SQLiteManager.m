//
//  SQLiteManager.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/13.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "SQLiteManager.h"

@interface SQLiteManager ()

// 数据库引用，使用它进行数据库操作
@property (nonatomic, assign) sqlite3 *db;

@end

@implementation SQLiteManager

+ (instancetype)sharedManager
{
    return [[self alloc] init];
}

- (void)openDataBaseWithName:(NSString *)dbName
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@.sqlite", [FileManager dirDoc], dbName];
    
    //如果有数据库直接打开，否则，创建打开
    if (sqlite3_open(dbPath.UTF8String, &_db) == SQLITE_OK) {
        ZLog(@"数据库打开成功");

    }else
    {
        ZLog(@"数据库打开失败");
    }
    
}

- (void)executeNonQuery:(NSString *)sql
{
    char *errmsg;
    
    //打开数据库
    NSString *dbPath = [NSString stringWithFormat:@"%@/config.sqlite", [FileManager dirDoc]];

    if (sqlite3_open(dbPath.UTF8String, &_db) ==SQLITE_OK) {

        if (sqlite3_exec(self.db, sql.UTF8String, NULL, NULL, &errmsg) !=SQLITE_OK) {
            
            ZLog(@"执行sql语句失败，错误信息：%s", errmsg);
        }
    }else
    {
        NSLog(@"打开数据库失败");
    }

}

- (NSMutableArray *)executeQuery:(NSString *)sql
{
    NSMutableArray *query = [NSMutableArray array];
    
    //打开数据库
    NSString *dbPath = [NSString stringWithFormat:@"%@/config.sqlite", [FileManager dirDoc]];
    
    if (sqlite3_open(dbPath.UTF8String, &_db) ==SQLITE_OK) {
        //评估语法正确性
        sqlite3_stmt *stmt;
        //检查语法正确性
        if (sqlite3_prepare(self.db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {

            while (sqlite3_step(stmt) == SQLITE_ROW) {
                NSMutableDictionary *queryMDic = [NSMutableDictionary dictionary];
                int columnCount = sqlite3_column_count(stmt);
                
                for (int i = 0; i < columnCount; i ++) {
                    
                    const char * name = sqlite3_column_name(stmt, i);//取得列名
                    const unsigned char * value = sqlite3_column_text(stmt, i);//取得某列的值
                    queryMDic[[NSString stringWithUTF8String:name]] = [NSString stringWithUTF8String:(const char *)value];
                    
                }
                
                [query addObject:queryMDic];
            }
            
        }else{
            
            ZLog(@"sql语句有问题");
        }
        
    }else {
        ZLog(@"打开数据库失败");
    }
    
    return query;
}


- (void)insertData:(NSDictionary<NSString *, id>*)dataDic intoTable:(NSString *)tName
{
    NSMutableString *keys = [[NSMutableString alloc] init];
    NSMutableString *values = [[NSMutableString alloc] init];
    
    for (int i = 0; i < dataDic.allKeys.count; i ++) {
        
        NSString *key = dataDic.allKeys[i];
        if (i < dataDic.count - 1) {
            
            [keys appendFormat:@"%@,", key];
            [values appendFormat:@"\"%@\",", [dataDic objectForKey:key]];
       }else{
            [keys appendFormat:@"%@", key];
            [values appendFormat:@"\"%@\"", [dataDic objectForKey:key]];
        }
        
    }
    
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@) values (%@);", tName, keys, values];
    [self executeNonQuery:sql];
}

- (void)deleteDataFromTable:(NSString *)tName whereString:(NSString *)wlStr
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"delete from %@ ", tName];
    
    if (wlStr != nil) {
        [sql appendFormat:@"where %@", wlStr];
    }
    
    [self executeNonQuery:sql];
    
}

- (void)updateTable:(NSString *)tName setState:(NSString *)state whereString:(NSString *)wlStr
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"update %@ ", tName];
    
    if (wlStr != nil) {
        [sql appendFormat:@"set state = '%@' where %@", state, wlStr];
    }
    
    [self executeNonQuery:sql];
}

@end
