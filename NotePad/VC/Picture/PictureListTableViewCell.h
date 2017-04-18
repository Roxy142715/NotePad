//
//  PictureListTableViewCell.h
//  NotePad
//
//  Created by 陈晓磊 on 17/3/7.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PictureModel;
@interface PictureListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *contentLab;

@property (nonatomic, strong) PictureModel *pictureModel;
@end
