
//
//  TextPostTableViewCell.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/6.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "TextPostTableViewCell.h"

#import "TextModel.h"

@implementation TextPostTableViewCell

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
    titleLab.textColor = [UIColor orangeColor];
    titleLab.font = [UIFont fontWithName:globalFont size:26];
    [self addSubview:titleLab];
    self.titleLab = titleLab;
    
    UILabel *dateLab = [[UILabel alloc] init];
    dateLab.font = [UIFont fontWithName:globalFont size:18];
    [self addSubview:dateLab];
    self.dateLab = dateLab;
    
    UILabel *allContentLab = [[UILabel alloc] init];
    allContentLab.numberOfLines = 0;
    allContentLab.font = [UIFont systemFontOfSize:20 weight:2];
    [self addSubview:allContentLab];
    
    self.allContentLab = allContentLab;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLab.frame = CGRectMake(0, 0, 200, 30);
    self.dateLab.frame = CGRectMake(0, self.titleLab.height, 200, 20);
    self.allContentLab.frame = CGRectMake(0, self.dateLab.y + self.dateLab.height, self.width, self.textModel.textH);
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = cellMargin;
    frame.size.width = ZScreenW - 2 * frame.origin.x;
    [super setFrame:frame];
}

- (void)setTextModel:(TextModel *)textModel
{
    _textModel = textModel;
    
   self.titleLab.text = [textModel.title substringFromIndex:10];
    
    NSString *dateFormater = [textModel.date substringFromIndex:9];
    NSRange yRange = {0, 4};
    NSRange MRange = {4, 2};
    NSRange dRange = {6, 2};
    NSRange HRange = {8, 2};
    NSRange mRange = {10, 2};
    NSRange sRange = {12, 2};
    dateFormater = [NSString stringWithFormat:@"%@年%@月%@日%@:%@:%@", [dateFormater substringWithRange:yRange], [dateFormater substringWithRange:MRange], [dateFormater substringWithRange:dRange], [dateFormater substringWithRange:HRange], [dateFormater substringWithRange:mRange], [dateFormater substringWithRange:sRange]];
    
   self.dateLab.text = dateFormater;
    
   self.allContentLab.text = _textModel.allContent;
}

@end
