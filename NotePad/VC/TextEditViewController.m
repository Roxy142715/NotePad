//
//  TextEditViewController.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/3.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "TextEditViewController.h"

#import "TextModel.h"

@interface TextEditViewController()

// db是数据库的句柄，就是数据库的象征，要对数据库进行增删改查，就得操作这个实例
@property (nonatomic, assign) sqlite3 *db;

@end

@implementation TextEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    
    [self setupTextView];
}

- (void)setupNav
{
    self.navigationItem.title = @"文本记事";
     
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存并返回" style:UIBarButtonItemStylePlain  target:self action:@selector(saveAndBack:)];

}

- (void)saveAndBack:(id)sender
{
    [self.textView resignFirstResponder];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请确认标题" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {

        textField.text = [self.textModel.title substringFromIndex:10];
        self.textField = textField;
        
    }];
    
    UIAlertAction *canaleAction = [UIAlertAction actionWithTitle:@"自动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveToFile];
        
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
    [alertVC addAction:canaleAction];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self saveToFile];
        
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
    [alertVC addAction:saveAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];

}

- (void)saveToFile
{
    NSString *fileTitle = @"";
    NSString *fileDate = @"";

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    if ([self.textField.text length] == 0) {
        fileTitle = dateTime;
    }else{
        fileTitle = self.textField.text;
    }
    
    if (self.date) {
        fileDate = self.date;
    }else{
        fileDate = dateTime;
    }

    NSString *cachePath = [FileManager dirLibCache];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.txt", cachePath, fileDate];
    
    BOOL isWriteSuccess = [FileManager writeFile:filePath content:self.textView.text];
    
    //生成配置文件textConfig.txt
    //每新建一个文档，会自动记录信息项
    
    if (isWriteSuccess) {
        NSString *configPath = [NSString stringWithFormat:@"%@/textConfig.txt", [FileManager dirLib]];
        NSString *configContent = nil;
        
        if (![FileManager isExitsFile:configPath]) [FileManager writeFile:configPath content:@""];
        
        //新建项记录
        if ([self.textView.text length] > 20) {
            configContent = [NSString stringWithFormat:@"fileDate:%@%@fileTitle:%@%@fileContent:%@%@", fileDate, itemSpe, fileTitle, itemSpe, [self.textView.text substringToIndex:20], atricleSpe];
        }else{
            configContent = [NSString stringWithFormat:@"fileDate:%@%@fileTitle:%@%@fileContent:%@%@", fileDate, itemSpe, fileTitle, itemSpe, self.textView.text, atricleSpe];
        }
        
        //追加新项
        [FileManager updateFile:configPath newContent:configContent];
    }
    
    //保存到数据库中
    NSDictionary *dataDic = @{@"date" : fileDate, @"title" : fileTitle, @"allContent" : self.textView.text };
    
    [[SQLiteManager sharedManager] insertData:dataDic intoTable:@
     "text"];
    
    
}

- (void)setTextModel:(TextModel *)textModel
{
    _textModel = textModel;
    
    [self setupTextView];
    
    self.textView.text = textModel.allContent;
}

- (void)setupTextView
{
    if (!self.textView) {
        self.textView = [[UITextView alloc] init];
    }
    [self.textView becomeFirstResponder];
    self.textView.frame = self.view.frame;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.textView.font = [UIFont systemFontOfSize:18];
    self.textView.delegate = self;
    
    [self.view addSubview:self.textView];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.textView becomeFirstResponder];
    
    //动画开始 textView 高度减少一个keyboardH，以保证内容不会被遮挡
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    
    self.textView.height -= keyboardH;
    
    [UIView commitAnimations];
  
}

@end
