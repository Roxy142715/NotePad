//
//  TodoModel.h
//  NotePad
//
//  Created by 陈晓磊 on 17/3/6.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoModel : NSObject

// 创建日期
@property (nonatomic, strong) NSString *date;
// 创建日期
@property (nonatomic, strong) NSString *deadline;
// 内容
@property (nonatomic, strong) NSString *content;
// 状态
@property (nonatomic, strong) NSString *state;

@end
