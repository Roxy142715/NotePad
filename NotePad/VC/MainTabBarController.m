//
//  MainTabBarController.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/2.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "MainTabBarController.h"

#import "MainTabBar.h"
#import "MainNavigationController.h"
#import "MainTableViewController.h"

#import "TextListViewController.h"
#import "TodoListViewController.h"
#import "PictureListViewController.h"

@interface MainTabBarController()
@end

@implementation MainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupChildVC:[[TextListViewController alloc] init] title:@"文本记事" image:@"text"];
    [self setupChildVC:[[TodoListViewController alloc] init] title:@"待办事项" image:@"todo"];
    [self setupChildVC:[[PictureListViewController alloc] init] title:@"多媒体记事" image:@"picture"];
    
    [self setValue:[[MainTabBar alloc] init] forKey:@"tabBar"];
    
    [self setupSQLite];


}

/**
 * 初始化子控制器
 */
- (void)setupChildVC:(MainTableViewController *)vc title:(NSString *)title image:(NSString *)image
{
    
    vc.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    
    //包装一个导航控制器，添加导航控制器为tabbar的子控制器
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:vc];

    [self addChildViewController:nav];
}

/**
 * 控制选项卡切换
 */
- (void)tabBar:(MainTabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    CGFloat selectImgViewY = 0;
    CGFloat selectImgViewW = ZScreenW / 3.0;
    CGFloat selectImgViewH = tabbarH;
    
    CGFloat selectImgViewX = selectImgViewW * index;
    tabBar.selectImgView.frame = CGRectMake(selectImgViewX, selectImgViewY, selectImgViewW, selectImgViewH);
    
}

/**
 * 创建 打开数据库
 */
- (void)setupSQLite
{
    [[SQLiteManager sharedManager] openDataBaseWithName:@"config"];
}

@end
