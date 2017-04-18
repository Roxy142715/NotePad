//
//  MainTableViewController.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/31.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "MainTableViewController.h"

#import "CustomModel.h"

@interface MainTableViewController ()<UISearchResultsUpdating, UISearchControllerDelegate>

@end

@implementation MainTableViewController

-(NSArray *)tableListMArr{
    if (!_tableListMArr) {
        _tableListMArr = [NSMutableArray arrayWithCapacity:20];//这个数量没什么用，但是要注意创建的数组是可变的
    }
    return _tableListMArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSearch];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.searchController.active) {
        
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}

- (void)setupSearch
{
    self.resultsController = [[MainResultTableViewController alloc] init];
    self.resultsController.view.backgroundColor = [UIColor whiteColor];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:_resultsController];
    self.searchController.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
}


#pragma mark - UISearchResultsUpdating

//  实现查询结果处理的代理方法，注：这是一个必须实现的方法。
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    //  设置谓词，谓词就是根据输入的内容去匹配数据，并返回一个查询的结果
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",self.searchController.searchBar.text];
    
    //  设置查询结果界面要显示的数据
    self.resultMArr = [NSMutableArray arrayWithArray:[[self loadAllDate] filteredArrayUsingPredicate:predicate]];
    self.resultsController.resultMArr = self.resultMArr;
    
    self.resultsController.resultModelMArr = [self loadAllModelByPredicate];
    
    //  不要忘记刷新结果数据界面
    [self.resultsController.tableView reloadData];
}

- (NSMutableArray *)loadAllDate
{
    NSMutableArray *allModelMArr = [TableViewData loadCustomData];
    
    NSMutableArray *allDateMArr = [[NSMutableArray alloc] init];
    
    for (CustomModel *model in allModelMArr) {
        
        [allDateMArr addObject:model.title];
    }
    
    return allDateMArr;
}


// 过滤后的模型数组
- (NSMutableArray *)loadAllModelByPredicate
{
    NSMutableArray *allModelMArr = [TableViewData loadCustomData];
    NSMutableArray *resultModelMArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < allModelMArr.count; i ++) {

        CustomModel *model = allModelMArr[i];
        
        for (NSString *predicate in self.resultMArr) {
            
            if ([model.title containsString:predicate])
            
                [resultModelMArr addObject:allModelMArr[i]];
        }
        
    }
    
    return resultModelMArr;
}


@end
