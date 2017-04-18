//
//  TextListTableViewCell.h
//  NotePad
//
//  Created by 陈晓磊 on 17/3/4.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextModel;

@interface TextListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *textLab;
@property (nonatomic, strong) UIImageView *voiceImg;

@property (nonatomic, strong) TextModel *textModel;

@end
