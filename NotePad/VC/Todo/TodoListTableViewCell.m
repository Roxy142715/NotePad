//
//  TodoListViewCell.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/6.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "TodoListTableViewCell.h"

#import "TodoModel.h"

@implementation TodoListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
    }
    return self;
}

- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *deadlineLab = [[UILabel alloc] init];
    deadlineLab.textColor = [UIColor orangeColor];
    deadlineLab.font = [UIFont fontWithName:globalFont size:44];
    [self addSubview:deadlineLab];
    self.deadlineLab = deadlineLab;
    
    UITextField *contentTextField = [[UITextField alloc] init];
    contentTextField.enabled = NO;
    contentTextField.font = [UIFont fontWithName:globalFont size:30];
    [self addSubview:contentTextField];
    self.contentTextField = contentTextField;
    
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:tipLab];
    self.tipLab = tipLab;
    
    UISwitch *statusSwitch = [[UISwitch alloc] init];
    [statusSwitch addTarget:self action:@selector(statusChange) forControlEvents:UIControlEventValueChanged];
    [self addSubview:statusSwitch];
    self.statusSwitch = statusSwitch;
    
}

- (void)statusChange
{
    if ([self.tipLab.text isEqualToString:todoReadya]) {
        [self.statusSwitch setOn:NO animated:YES];
        self.tipLab.text = todoDone;
        self.backgroundColor = [UIColor lightGrayColor];
    }else{
        [self.statusSwitch setOn:YES animated:YES];
        self.tipLab.text = todoReadya;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    [self updateStateToFile:self];
}

- (void)updateStateToFile:(id)sender
{
    NSString *configPath = [NSString stringWithFormat:@"%@/todoConfig.txt", [FileManager dirLib]];
    NSString *configContent = [FileManager readFile:configPath];
    NSMutableArray *configMArr = [[NSMutableArray alloc] init];
    NSArray *configArr = [configContent componentsSeparatedByString:atricleSpe];
    for (int i = 0; i < configArr.count - 1; i ++) {
        [configMArr addObject:configArr[i]];
    }
    
    NSString *newContent = @"";
    
    NSString *dateFormatter = [self.todoModel.date substringFromIndex:9];
    
    if ([self.statusSwitch isOn]) {
        newContent = [NSString stringWithFormat:@"%@%@%@%@state:%@%@%@", self.todoModel.date, itemSpe, self.todoModel.deadline, itemSpe, todoReadya, itemSpe, self.todoModel.content];
        
        [[SQLiteManager sharedManager] updateTable:@"todo" setState:todoReadya whereString:[NSString stringWithFormat:@"date = %@", dateFormatter]];
        
    }else{
        newContent = [NSString stringWithFormat:@"%@%@%@%@state:%@%@%@", self.todoModel.date, itemSpe, self.todoModel.deadline, itemSpe, todoDone, itemSpe, self.todoModel.content];
        
        [[SQLiteManager sharedManager] updateTable:@"todo" setState:todoDone whereString:[NSString stringWithFormat:@"date = %@", dateFormatter]];
    }

    [configMArr replaceObjectAtIndex:self.tag withObject:newContent];
    configContent = [configMArr componentsJoinedByString:atricleSpe];
    configContent = [NSString stringWithFormat:@"%@%@", configContent, atricleSpe];
    [FileManager writeFile:configPath content:configContent];

}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.deadlineLab.frame = CGRectMake(cellMargin, cellMargin, 300, 30);
    self.contentTextField.frame = CGRectMake(cellMargin, self.deadlineLab.y + self.deadlineLab.height + cellMargin, self.width - 2 * cellMargin, 30);
    self.tipLab.frame = CGRectMake(ZScreenW - 50, cellMargin, 70, 20);
    self.statusSwitch.frame = CGRectMake(ZScreenW - 55, 40, 100, 30);
}

//- (void)setFrame:(CGRect)frame
//{
//    frame.origin.x = cellMargin;
//    frame.origin.y += cellMargin;
//    frame.size.width = ZScreenW - 2 * frame.origin.x;
//    
//    [super setFrame:frame];
//}

- (void)setTodoModel:(TodoModel *)todoModel
{
    _todoModel = todoModel;
    
    self.deadlineLab.text = [todoModel.deadline substringFromIndex:9];
    
    self.contentTextField.text = [todoModel.content substringFromIndex:12];
    
    self.tipLab.text = [todoModel.state substringFromIndex:6];
    
    if ([self.tipLab.text isEqualToString:todoReadya]) {
        [self.statusSwitch setOn:YES animated:YES];
    }else{
        [self.statusSwitch setOn:NO animated:YES];
    }
}

@end
