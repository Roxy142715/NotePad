//
//  TextEditViewController.h
//  NotePad
//
//  Created by 陈晓磊 on 17/3/3.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextModel;
@interface TextEditViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString *date;

@property (nonatomic, strong) TextModel *textModel;

@end
