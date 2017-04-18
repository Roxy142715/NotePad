//
//  TextModel.h
//  NotePad
//
//  Created by 陈晓磊 on 17/3/3.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextModel : NSObject

// 创建日期
@property (nonatomic, strong) NSString *date;
// 标题
@property (nonatomic, strong) NSString *title;
// 简介
@property (nonatomic, strong) NSString *text;
// 所有内容
@property (nonatomic, strong) NSString *allContent;

/* textPostCell 的高度 */
@property (nonatomic, assign, readonly) CGFloat textH;
@property (nonatomic, assign, readonly) CGFloat textPostCellHeight;

@end
