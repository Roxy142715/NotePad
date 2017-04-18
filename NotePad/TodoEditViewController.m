//
//  TodoEditViewController.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/22.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "TodoEditViewController.h"

@interface TodoEditViewController ()<UITextFieldDelegate>

@end

@implementation TodoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    [self setupView];
}

- (void)setupNav
{
    self.navigationItem.title = @"待办事项";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存并返回" style:UIBarButtonItemStylePlain  target:self action:@selector(saveAndBack)];
    
}

- (void)saveAndBack
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请再次确认" message:nil preferredStyle:UIAlertControllerStyleAlert];
 
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.enabled = NO;
        textField.text = self.titleTf.text;
        textField.textAlignment = NSTextAlignmentCenter;
        
    }];

    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.enabled = NO;
        textField.text = self.deadlineTf.text;
        textField.textAlignment = NSTextAlignmentCenter;
        
    }];

    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [alertVC addAction:cancleAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self saveToFile];
        
    }];
    [alertVC addAction:okAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];

}

- (void)setupView
{
    UIView *detailView = [[UIView alloc] init];
    detailView.layer.shadowColor = [UIColor blackColor].CGColor;
    detailView.layer.shadowOffset = CGSizeMake(-2, -2);
    detailView.layer.shadowOpacity = 0.5;
    detailView.layer.shadowRadius = 10;
    detailView.layer.borderWidth = 5;
    detailView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:detailView];
    self.detailView = detailView;
    
    UITextField *titleTf = [[UITextField alloc] init];
    titleTf.textAlignment = NSTextAlignmentCenter;
    titleTf.layer.borderColor = [UIColor whiteColor].CGColor;
    titleTf.layer.borderWidth = 1;
    [detailView addSubview:titleTf];
    self.titleTf = titleTf;
    
    UITextField *deadLineTf = [[UITextField alloc] init];
    deadLineTf.placeholder = @"期限时间";
    [deadLineTf setEnabled:NO];
    deadLineTf.textAlignment = NSTextAlignmentCenter;
    deadLineTf.layer.borderColor = [UIColor whiteColor].CGColor;
    deadLineTf.layer.borderWidth = 2;
    [detailView addSubview:deadLineTf];
    self.deadlineTf = deadLineTf;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    [datePicker setTimeZone:[NSTimeZone localTimeZone]];
    [datePicker setDate:[NSDate date] animated:YES];
    [datePicker setDatePickerMode:UIDatePickerModeTime];
    [datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    self.datePicker = datePicker;
    
}

- (void)viewDidLayoutSubviews
{
    self.detailView.frame = CGRectMake(cellMargin * 2, cellMargin * 8, ZScreenW - cellMargin * 4, 110);
    self.titleTf.frame = CGRectMake(cellMargin, cellMargin, self.detailView.width - cellMargin * 2, 40);
    self.deadlineTf.frame = CGRectMake(cellMargin, self.titleTf.y + self.titleTf.height + cellMargin, self.detailView.width - cellMargin * 2, 40);
    
    self.datePicker.frame = CGRectMake(cellMargin * 2, ZScreenH * 0.35, ZScreenW - cellMargin * 4, 150);
    
}

- (void)saveToFile
{
    //保存 日期date
    //保存 事件content
    NSString *date = @"";

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    date = [formatter stringFromDate:[NSDate date]];
    
    NSString *cachePath = [FileManager dirLibCache];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.txt", cachePath, date];
    
    BOOL isWriteSuccess = [FileManager writeFile:filePath content:self.titleTf.text];
    
    //生成配置文件
    if (isWriteSuccess) {
        
        NSString *configPath = [NSString stringWithFormat:@"%@/todoConfig.txt", [FileManager dirLib]];
        NSString *configContent = @"";
        
        //判断文件是否存在，若不存在，创建
        if (![FileManager isExitsFile:configPath]) [FileManager writeFile:configPath content:@""];
        
        configContent = [NSString stringWithFormat:@"fileDate:%@%@deadline:%@%@state:%@%@fileContent:%@%@", date, itemSpe, self.deadlineTf.text, itemSpe, todoReadya, itemSpe, self.titleTf.text, atricleSpe];
        
        //追加新项
        [FileManager updateFile:configPath newContent:configContent];
    }
    
    
    //保存到数据库中
    NSDictionary *dataDic = @{@"date" : date, @"deadline": self.deadlineTf.text, @"content" : self.titleTf.text, @"state" : todoReadya };
    
    [[SQLiteManager sharedManager] insertData:dataDic intoTable:@
     "todo"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)datePickerValueChanged
{
    NSString *date = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    date = [formatter stringFromDate:[self.datePicker date]];
    
    self.deadlineTf.text = [NSString stringWithFormat:@"%@",date];
}

@end
