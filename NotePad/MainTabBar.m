//
//  MainTabBar.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/2.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "MainTabBar.h"

@implementation MainTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundImage = [UIImage imageNamed:@"tab_bg_all"];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    UIImageView *selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ZScreenW / 3.0, tabbarH)];
    selectImgView.image = [UIImage imageNamed:@"selectTabbar_bg_all1"];
    [self addSubview:selectImgView];
    self.selectImgView = selectImgView;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.height = tabbarH;
    self.y = [self superview].height - tabbarH;
    
    //此处需要设置barStyle，否则颜色会分为上下两层
    self.barStyle = UIBarStyleBlack;

}

@end
