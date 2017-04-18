//
//  TextPostTableViewCell.h
//  NotePad
//
//  Created by 陈晓磊 on 17/3/6.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextModel;
@interface TextPostTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *allContentLab;

@property (nonatomic, strong) TextModel *textModel;

@end
