//
//  PictureModel.h
//  NotePad
//
//  Created by 陈晓磊 on 17/3/7.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureModel : NSObject

// 创建日期
@property (nonatomic, strong) NSString *date;
// 内容
@property (nonatomic, strong) NSString *content;
// 图片路径
@property (nonatomic, strong) NSString *picture;

@end
