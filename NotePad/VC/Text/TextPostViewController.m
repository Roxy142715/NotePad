//
//  TextPostTableViewController.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/6.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "TextPostViewController.h"

#import "TextModel.h"
#import "TextPostTableViewCell.h"

@interface TextPostViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation TextPostViewController

static NSString *textPost_cell = @"textPost_cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.textListMArr.count;
}

- (TextPostTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TextPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textPost_cell];
    
    if (!cell) {
        cell = [[TextPostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textPost_cell];
    }
    cell.textModel = self.textListMArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextModel *textModel = self.textListMArr[indexPath.row];
    
    return textModel.textPostCellHeight;
}

#pragma mark - 数据

- (void)requestData
{
    self.textListMArr = [TableViewData loadTextData];
    
    [self updateView];
}

- (void)updateView
{
    [self.tableView reloadData];
}
@end
