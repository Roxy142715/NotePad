//
//  MainShowTableViewCell.m
//  NotePad
//
//  Created by 陈晓磊 on 17/4/6.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "MainShowTableViewCell.h"

#import "CustomModel.h"
@implementation MainShowTableViewCell

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
    
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.font = [UIFont systemFontOfSize:26];
    contentLab.numberOfLines = 0;
    [self addSubview:contentLab];
    self.contentLab = contentLab;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //计算文字的高度
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:26];
    
    CGFloat textH = 30;
    
    if (self.contentLab.text != nil) {
        
        textH = [self.contentLab.text boundingRectWithSize:CGSizeMake(ZScreenW - 2 * cellMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
    }
    
    self.titleLab.frame = CGRectMake(cellMargin, 0, 200, 30);
    self.contentLab.frame = CGRectMake(cellMargin, self.titleLab.y + self.titleLab.height, self.width, textH);
    
    
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = cellMargin;
    frame.origin.y = cellMargin * 8;
    frame.size.width = ZScreenW - 2 * frame.origin.x;
    
    [super setFrame:frame];
}

- (void)setCustomModel:(CustomModel *)customModel
{
    _customModel = customModel;
    
    self.titleLab.text = customModel.title;
    
    self.contentLab.text = customModel.content;
    
    if([customModel.content  isEqual: @"(null)"] && customModel.picture == nil)//语音记事
    {
        //出现一个语音按钮
        UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        voiceBtn.frame = CGRectMake(0, 30, self.width, 30);
        [self.contentLab removeFromSuperview];
        [voiceBtn setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        voiceBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, ZScreenW * 0.8);
        [self addSubview:voiceBtn];
        self.voiceBtn = voiceBtn;
        
    }else if(customModel.picture != nil)//图文记事
    {
        [self.contentLab removeFromSuperview];
        NSString *picturePath = [NSString stringWithFormat:@"%@/%@", [FileManager dirLibCache], [customModel.picture substringFromIndex:9]];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(0, 40, ZScreenW - 20, 250);
        imgView.image = [UIImage imageWithContentsOfFile:picturePath];
        
        UILabel *contentLab = [[UILabel alloc] init];
        contentLab.textColor = [UIColor whiteColor];
        contentLab.font = [UIFont fontWithName:globalFont size:30];
        contentLab.text = customModel.content;
        contentLab.frame = CGRectMake(cellMargin, 200, imgView.width - 2 * cellMargin, 30);
        [imgView addSubview:contentLab];
        
        [self addSubview:imgView];
        
        
    }
}

@end
