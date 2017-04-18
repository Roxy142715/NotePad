//
//  TodoListViewController.h
//  NotePad
//
//  Created by 陈晓磊 on 17/3/2.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoListViewController : MainTableViewController

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *deadlineLab;
@property (nonatomic, strong) NSMutableArray *todoListMArr;

@property (nonatomic, strong) NSMutableArray *todoMArr;

@end
