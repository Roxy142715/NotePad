//
//  ViewController.m
//  NotePad
//
//  Created by 陈晓磊 on 17/2/28.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) sqlite3 *db;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    [self setupBtns];

    
}

- (void)setupBtns
{
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [btn1 setTitle:@"1 增加通知" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(insertBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 220, 100, 100)];
    [btn2 setTitle:@"2 删除" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(deleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(100, 330, 100, 100)];
    [btn3 setTitle:@"3 修改" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(updateBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(100, 440, 100, 100)];
    [btn4 setTitle:@"4 查询" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(selectBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
}

- (void)insertBtn
{

}

- (void)deleteBtn
{
    
}

- (void)updateBtn
{
    
}

- (void)selectBtn
{

    
}

- (void)setupSQLite
{

}

@end
