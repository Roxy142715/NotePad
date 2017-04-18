//
//  MainTabBarController.h
//  NotePad
//
//  Created by 陈晓磊 on 17/3/2.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarController : UITabBarController

- (void)setupChildVC:(UITableViewController *)vc title:(NSString *)title image:(NSString *)image;

@end
