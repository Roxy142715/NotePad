//
//  CustomModel.h
//  NotePad
//
//  Created by 陈晓磊 on 17/4/6.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomModel : NSObject

// 标题 (date)
@property (nonatomic, strong) NSString *title;
// 内容 (text / todo)
@property (nonatomic, strong) NSString *content;
// 图片路径 (picture)
@property (nonatomic, strong) NSString *picture;

/* customShowCell 的高度 */
@property (nonatomic, assign) CGFloat customCellH;

@end
