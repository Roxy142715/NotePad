//
//  TodoListViewController.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/2.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "TodoListViewController.h"

#import "TodoEditViewController.h"
#import "TodoModel.h"
#import "TodoListTableViewCell.h"
#import <UserNotifications/UserNotifications.h>

@interface TodoListViewController ()<UITableViewDataSource, UITableViewDelegate, UNUserNotificationCenterDelegate>

@end

@implementation TodoListViewController

static NSString *todoList_cell = @"todoList_cell";

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
    
    //获得模型
    TodoModel *todoModel = [[TodoModel alloc] init];
    
    for (int i = 0; i < self.todoListMArr.count; i ++) {
        
        todoModel = self.todoListMArr[i];
        
        if ([todoModel.state containsString:todoReadya]) {
        
            [self addTimingNotication:todoModel];
        }
        
    }

}

- (void)setupNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(gotoEdit)];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)gotoEdit
{
    [self.navigationController pushViewController:[[TodoEditViewController alloc] init] animated:YES] ;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.todoListMArr ? self.todoListMArr.count: 0;
}

- (TodoListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:todoList_cell];
    if (!cell) {
        cell = [[TodoListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:todoList_cell];
    }
    cell.tag = indexPath.row;
    cell.todoModel = self.todoListMArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return todoListCellH;
}

// 设置cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 设置编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}
// 进入编辑模式，按下出现的编辑按钮后，进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        TodoModel *todoModel = self.todoListMArr[indexPath.row];
        
        //删除本地文件
        NSString *dateFormater = [todoModel.date substringFromIndex:9];
        NSString *deleteFilePath = [NSString stringWithFormat:@"%@/%@.txt", [FileManager dirLibCache], dateFormater];
        [FileManager deleteFile:deleteFilePath];
        
        //修改config文件
        NSString *configPath = [NSString stringWithFormat:@"%@/todoConfig.txt", [FileManager dirLib]];
        NSString *configContent = [FileManager readFile:configPath];
        
        NSMutableArray *configMArr = [[NSMutableArray alloc] init];
        NSArray *configArr = [configContent componentsSeparatedByString:atricleSpe];
        for (int i = 0; i < configArr.count; i ++) {
            [configMArr addObject:configArr[i]];
        }
        [configMArr removeObjectAtIndex:indexPath.row];
        configContent = [configMArr componentsJoinedByString:atricleSpe];
         ;
        
        //修改self.textListMArr
        [self.todoListMArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        //对数据库进行修改
        NSString *wlStr = [NSString stringWithFormat:@"date = %@", dateFormater];
        [[SQLiteManager sharedManager] deleteDataFromTable:@"todo" whereString:wlStr];
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
    self.todoListMArr = [TableViewData loadTodoData];
    
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
    NSString *sql = @"create table if not exists todo (id integer primary key autoincrement, date text, deadline text, content text, state text)";
    
    [[SQLiteManager sharedManager] executeNonQuery:sql];
    
}

- (void)selectTable
{
    self.todoMArr = [[SQLiteManager sharedManager] executeQuery:@"select * from todo"];
}

#pragma mark - 定时提醒

- (void)addTimingNotication:(TodoModel *)todoModel
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    //必须写代理，不然无法监听通知的接受与点击
    center.delegate = self;
    
    // 1 请求用户授权
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound +UNAuthorizationOptionBadge + UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
    }];
    //注册通知
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    // 2 通知内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:[todoModel.content substringFromIndex:12]arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:[todoModel.state substringFromIndex:6] arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    // 3 设置触发时间 定时提醒
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    NSRange HRange = {9, 2};
    NSRange mRange = {12, 2};
    
    components.hour = [[todoModel.deadline substringWithRange:HRange] integerValue];
    components.minute = [[todoModel.deadline substringWithRange:mRange] integerValue];
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];
    
    // 4 创建一个发送请求
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[todoModel.date substringFromIndex:9] content:content trigger:trigger];
    
    // 5 将请求添加到通知中心
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
    
}

#pragma mark - UNUserNotificationCenterDelegate

// 接收通知，处理用户行为

//如果需要在应用在前台也展示通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    completionHandler(UNNotificationPresentationOptionBadge + UNNotificationPresentationOptionSound + UNNotificationPresentationOptionAlert);
    
}

// 触发通知动作时回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    //修改图标数字
    [UIApplication sharedApplication].applicationIconBadgeNumber -= 1;
    
    //处理数据 拿到特定通知的标示符
    NSString *identifier = response.notification.request.identifier;
    
    //删除特定的通知
    [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[identifier]];
    
    
    completionHandler();
    
}

@end
