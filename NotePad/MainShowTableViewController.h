//
//  MainShowTableViewController.h
//  NotePad
//
//  Created by 陈晓磊 on 17/4/6.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomModel;
@interface MainShowTableViewController : UITableViewController

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong)  CustomModel *showModel;

@end
