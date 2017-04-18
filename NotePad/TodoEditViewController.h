//
//  TodoEditViewController.h
//  NotePad
//
//  Created by 陈晓磊 on 17/3/22.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoEditViewController : UIViewController

@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UITextField *titleTf;
@property (nonatomic, strong) UITextField *deadlineTf;

@property (nonatomic, strong) UIDatePicker *datePicker;

@end
