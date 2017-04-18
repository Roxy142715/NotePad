//
//  PictureListTableViewCell.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/7.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "PictureListTableViewCell.h"

#import "PictureModel.h"
@implementation PictureListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
    }
    return self;
}

- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *dateLab = [[UILabel alloc] init];
    dateLab.font = [UIFont fontWithName:globalFont size:20];
    dateLab.textColor = [UIColor orangeColor];
    [self addSubview:dateLab];
    self.dateLab = dateLab;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [self addSubview:imgView];
    self.imgView = imgView;
    
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.textColor = [UIColor whiteColor];
    contentLab.font = [UIFont fontWithName:globalFont size:30];
    [self addSubview:contentLab];
    self.contentLab = contentLab;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.dateLab.frame = CGRectMake(cellMargin, cellMargin, 200, 30);
    self.imgView.frame = CGRectMake(cellMargin, 40, ZScreenW - 20, 250);
    self.contentLab.frame = CGRectMake(cellMargin * 2, 250, self.imgView.width - 2 * cellMargin, 30);
}

- (void)setPictureModel:(PictureModel *)pictureModel
{
    _pictureModel = pictureModel;
    
    NSString *dateFormater = [pictureModel.date substringFromIndex:9];
    
    if (dateFormater != nil)
    {
        NSRange yRange = {0, 4};
        NSRange MRange = {4, 2};
        NSRange dRange = {6, 2};
        NSRange HRange = {8, 2};
        NSRange mRange = {10, 2};
        NSRange sRange = {12, 2};
        
        dateFormater = [NSString stringWithFormat:@"%@年%@月%@日%@:%@:%@", [dateFormater substringWithRange:yRange], [dateFormater substringWithRange:MRange], [dateFormater substringWithRange:dRange], [dateFormater substringWithRange:HRange], [dateFormater substringWithRange:mRange], [dateFormater substringWithRange:sRange]];
        
         self.dateLab.text = dateFormater;
    }
    
    NSString *picturePath = [NSString stringWithFormat:@"%@/%@", [FileManager dirLibCache], [pictureModel.picture substringFromIndex:9]];
    
    if (pictureModel.content != nil && pictureModel.picture != nil){//图文记事

        self.imgView.image = [UIImage imageWithContentsOfFile:picturePath];
        self.contentLab.text = [pictureModel.content substringFromIndex:12];
        
    }else if (pictureModel.content == nil && pictureModel.picture != nil) {//画板记事
        
        self.imgView.image = [UIImage imageWithContentsOfFile:picturePath];
        self.contentLab.text = @" ";
    }
}

@end
