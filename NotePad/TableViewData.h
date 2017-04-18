//
//  TableViewData.h
//  NotePad
//
//  Created by 陈晓磊 on 17/3/4.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewData : NSObject

+ (id)loadTextData;

+ (id)loadTodoData;

+ (id)loadPictureData;

+ (id)loadCustomData;

@end
