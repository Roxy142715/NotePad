//
//  TextListTableViewCell.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/4.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "TextListTableViewCell.h"
#import "TextModel.h"

@implementation TextListTableViewCell

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
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont fontWithName:globalFont size:30];
    titleLab.textColor = [UIColor orangeColor];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    
    UILabel *dateLab = [[UILabel alloc] init];
    dateLab.font = [UIFont fontWithName:globalFont size:16];
    dateLab.textColor = [UIColor orangeColor];
    [self.contentView addSubview:dateLab];
    self.dateLab = dateLab;
    
    UILabel *textLab = [[UILabel alloc] init];
    textLab.font = [UIFont fontWithName:globalFont size:28];
    [self.contentView addSubview:textLab];
    self.textLab = textLab;
    
    UIImageView *voiceImg = [[UIImageView alloc] init];
    voiceImg.image = [UIImage imageNamed:@"voice"];
    self.voiceImg = voiceImg;
}

- (void)setTextModel:(TextModel *)textModel
{
    _textModel = textModel;
    
    self.titleLab.text = [textModel.title substringFromIndex:10];
    
    NSString *dateFormater = [textModel.date substringFromIndex:9];
    
    if (dateFormater != nil)
    {
        NSRange yRange = {0, 4};
        NSRange MRange = {4, 2};
        NSRange dRange = {6, 2};
        
        dateFormater = [NSString stringWithFormat:@"%@年%@月%@日", [dateFormater substringWithRange:yRange], [dateFormater substringWithRange:MRange], [dateFormater substringWithRange:dRange]];
        
        self.dateLab.text = dateFormater;
    }
    
    if (_textModel.allContent == nil) {
        
        self.textLab.hidden = YES;
        
        //出现一个语音按钮
        [self addSubview:self.voiceImg];
        
    }else{
        self.textLab.text = [textModel.text substringFromIndex:12];
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLab.frame = CGRectMake(cellMargin, cellMargin, 200, 25);
    self.dateLab.frame = CGRectMake(self.width - 100, cellMargin, 100, 25);
    self.textLab.frame = CGRectMake(cellMargin, 2 * cellMargin + self.titleLab.height, self.width - 2 * cellMargin, 25);
    self.voiceImg.frame = CGRectMake(cellMargin * 2, 2 * cellMargin + self.titleLab.height, 25, 25);
    
}

//- (void)setFrame:(CGRect)frame
//{
//    frame.origin.x = cellMargin;
//    frame.origin.y += cellMargin;
//    frame.size.width = ZScreenW - 2 * frame.origin.x;
//    [super setFrame:frame];
//}

@end
