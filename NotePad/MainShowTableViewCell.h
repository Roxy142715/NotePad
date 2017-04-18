//
//  MainShowTableViewCell.h
//  NotePad
//
//  Created by 陈晓磊 on 17/4/6.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomModel;
@interface MainShowTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIButton *voiceBtn;

@property (nonatomic, strong) CustomModel *customModel;

@end
