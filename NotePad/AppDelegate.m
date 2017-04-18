//
//  AppDelegate.m
//  NotePad
//
//  Created by 陈晓磊 on 17/2/28.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "AppDelegate.h"

#import <UserNotifications/UserNotifications.h>

#import "MainTabBarController.h"
#import "TodoModel.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@property (nonatomic, strong) NSMutableArray *todoListMArr;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    MainTabBarController *mainVC = [[MainTabBarController alloc] init];
    self.window.rootViewController = mainVC;
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self requestData];
    
    if (self.todoListMArr.count != 0) {
        
        //添加通知
        [self addNotication];
        
    }
    
    return YES;
}

- (void)addNotication
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
    content.badge = [NSNumber numberWithInteger:[UIApplication sharedApplication].applicationIconBadgeNumber + 1];
    [UIApplication sharedApplication].applicationIconBadgeNumber = [content.badge integerValue];
    content.body = @"还有待做事项";
    content.sound = [UNNotificationSound defaultSound];

    // 3 设置触发时间 立即提醒
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    // 4 创建一个发送请求
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"my_notification" content:content trigger:trigger];
    
    // 5 将请求添加到通知中心
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
    
}

- (void)addTimingNotication:(TodoModel *)todoModel
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    //必须写代理，不然无法监听通知的接受与点击
    center.delegate = self;
    
    //注册通知
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    // 2 通知内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:[todoModel.content substringFromIndex:12]arguments:nil];
    content.badge = [NSNumber numberWithInteger:[UIApplication sharedApplication].applicationIconBadgeNumber + 1];
    [UIApplication sharedApplication].applicationIconBadgeNumber = [content.badge integerValue];
    content.body = [NSString localizedUserNotificationStringForKey:[todoModel.state substringFromIndex:6] arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    // 3 设置触发时间 定时提醒
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    NSRange HRange = {17, 2};
    NSRange mRange = {19, 2};
    
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
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 数据

- (void)requestData
{
    self.todoListMArr = [TableViewData loadTodoData];
    
}

@end
