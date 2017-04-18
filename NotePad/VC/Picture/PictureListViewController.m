//
//  PictureListViewController.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/2.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "PictureListViewController.h"

#import "PictureModel.h"
#import "PictureEditViewController.h"
#import "PictureListTableViewCell.h"
#import "PaletteViewController.h"

@interface PictureListViewController ()<UITableViewDataSource, UITableViewDelegate>


@end

@implementation PictureListViewController

static NSString *pictureList_cell = @"pictureList_cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self createTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestData];
    
    [self selectTable];
 
}

- (void)setupNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(gotoEdit)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(gotoPalette)];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
   
}

- (void)gotoEdit
{
    [self.navigationController pushViewController:[[PictureEditViewController alloc] init] animated:YES];
    
}

- (void)gotoPalette
{
    [self.navigationController pushViewController:[[PaletteViewController alloc] init] animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tableListMArr ? self.tableListMArr.count : 0;
}

- (PictureListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    PictureListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pictureList_cell];
    
    if (!cell) {
        
        cell = [[PictureListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pictureList_cell];
    }
    
    cell.pictureModel = self.tableListMArr[indexPath.row];
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return pictureListCellH;
}

// 设置cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}
// 设置编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleDelete;
}
// 进入编辑模式，按下出现的编辑按钮后，进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        PictureModel *pictureModel = self.tableListMArr[indexPath.row];
        
        //删除本地文件
        NSString *dateFormatter = [pictureModel.date substringFromIndex:9];
        NSString *deleteFilePath = [NSString stringWithFormat:@"%@/%@.png", [FileManager dirLibCache], dateFormatter];
        [FileManager deleteFile:deleteFilePath];
        
        //修改config文件
        NSString *configPath = [NSString stringWithFormat:@"%@/pictureConfig.txt", [FileManager dirLib]];
        NSString *configContent = [FileManager readFile:configPath];
        
        NSMutableArray *configMArr = [[NSMutableArray alloc] init];
        NSArray *configArr = [configContent componentsSeparatedByString:atricleSpe];
        
        for (int i = 0; i < configArr.count; i ++) {
            [configMArr addObject:configArr[i]];
        }
        
        [configMArr removeObjectAtIndex:indexPath.row];
        configContent = [configMArr componentsJoinedByString:atricleSpe];
        [FileManager writeFile:configPath content:configContent];
        
        //修改self.tableListMArr
        [self.tableListMArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        //对数据库进行修改
        NSString *wlStr = [NSString stringWithFormat:@"date = %@", dateFormatter];
        [[SQLiteManager sharedManager] deleteDataFromTable:@"picture" whereString:wlStr];
        [self selectTable];

    }
}
//修改编辑按钮的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - 数据

- (void)requestData
{
    self.tableListMArr = [TableViewData loadPictureData];

    [self updateView];
}

- (void)updateView
{
    [self.tableView reloadData];
}

# pragma mark - sqlite 数据处理

// 新建表
- (void)createTable
{
    NSString *sql = @"create table if not exists picture (id integer primary key autoincrement, date text, content text, picture text)";
    
    [[SQLiteManager sharedManager] executeNonQuery:sql];
    
}

- (void)selectTable
{
    self.tableMArr = [[SQLiteManager sharedManager] executeQuery:@"select * from picture"];
}


@end
