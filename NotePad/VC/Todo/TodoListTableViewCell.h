//
//  TodoListViewCell.h
//  NotePad
//
//  Created by 陈晓磊 on 17/3/6.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TodoModel;
@interface TodoListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *deadlineLab;
@property (nonatomic, strong) UITextField *contentTextField;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UISwitch *statusSwitch;

@property (nonatomic, strong) TodoModel *todoModel;

@end
