//
//  TableViewData.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/4.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "TableViewData.h"

#import "TextModel.h"
#import "TodoModel.h"
#import "PictureModel.h"
#import "CustomModel.h"

@implementation TableViewData

+ (id)loadTextData
{
    NSString *configPath = [NSString stringWithFormat:@"%@/textConfig.txt", [FileManager dirLib]];
    NSString *configContent = [FileManager readFile:configPath];
    
    if (![FileManager isExitsFile:configPath])  return configContent;
    
    NSMutableArray *configMArr = [[NSMutableArray alloc] init];
    NSArray *configArr = [configContent componentsSeparatedByString:atricleSpe];
    for (int i = 0; i < configArr.count - 1; i ++) {
        NSArray *itemArr = [configArr[i] componentsSeparatedByString:itemSpe];
        TextModel *textModel = [[TextModel alloc] init];

        textModel.title = itemArr[1];
        
        textModel.date = itemArr[0];
        
        textModel.text = itemArr[2];
        
        NSString *allCotentFormater = [itemArr[0] substringFromIndex:9];
        NSString *newFilePath = [NSString stringWithFormat:@"%@/%@.txt", [FileManager dirLibCache], allCotentFormater];
        textModel.allContent = [FileManager readFile:newFilePath];
        
        [configMArr insertObject:textModel atIndex:configMArr.count];
    }
   
    return configMArr;
    
}

+ (id)loadTodoData
{
    //直接读取配置文件
   
    NSString *configPath = [NSString stringWithFormat:@"%@/todoConfig.txt", [FileManager dirLib]];
    NSString *configContent = [FileManager readFile:configPath];
    
    if (![FileManager isExitsFile:configPath]) return configContent;
    
    //将配置文件分隔存入模型数组
    NSMutableArray *confirMArr = [[NSMutableArray alloc] init];
    NSArray *configArr = [configContent componentsSeparatedByString:atricleSpe];
    for (int i = 0; i < configArr.count - 1; i ++) {
        NSArray *itemArr = [configArr[i] componentsSeparatedByString:itemSpe];
        
        TodoModel *todoModel = [[TodoModel alloc] init];
        
        todoModel.date = itemArr[0];
        todoModel.deadline = itemArr[1];
        todoModel.state = itemArr[2];
        todoModel.content = itemArr[3];
        
        [confirMArr insertObject:todoModel atIndex:confirMArr.count];
    }
    
    return confirMArr;
}

+ (id)loadPictureData
{
    //直接读取配置文件
    NSString *configPath = [NSString stringWithFormat:@"%@/pictureConfig.txt", [FileManager dirLib]];
    NSString *configContent = [FileManager readFile:configPath];
    
    if (![FileManager isExitsFile:configPath]) return configContent;
    
    NSMutableArray *configMArr = [[NSMutableArray alloc] init];
    NSArray *configArr = [configContent componentsSeparatedByString:atricleSpe];
    for (int i = 0; i < configArr.count - 1; i ++) {
        
        NSArray *itemArr = [configArr[i] componentsSeparatedByString:itemSpe];
        
        PictureModel *pictureModel = [[PictureModel alloc] init];
        
        pictureModel.date = itemArr[0];
        pictureModel.picture = itemArr[1];
        pictureModel.content = itemArr[2];
        
        [configMArr insertObject:pictureModel atIndex:configMArr.count];
        
    }
    
    return configMArr;
}

+ (id)loadCustomData
{
    
    NSMutableArray *customMArr = [[NSMutableArray alloc] init];
    
    NSMutableArray *textMArr = [TableViewData loadTextData];
    for (TextModel *model in textMArr) {
        
        CustomModel *customModel = [[CustomModel alloc] init];

        if (model.title != nil) {
            
            customModel.title = [model.title substringFromIndex:10];
        }else{
            customModel.title = [model.date substringFromIndex:9];
        }
        
        customModel.content = [model.text substringFromIndex:12];
        customModel.customCellH = model.textPostCellHeight;
        
        [customMArr insertObject:customModel atIndex:customMArr.count];
    }
    
    NSMutableArray *todoMArr = [TableViewData loadTodoData];
    
    for (TodoModel *model in todoMArr) {
        
        CustomModel *customModel = [[CustomModel alloc] init];
        
        customModel.title = [model.date substringFromIndex:9];
        customModel.content = [model.content substringFromIndex:12];
        customModel.customCellH = todoListCellH;
        
        [customMArr insertObject:customModel atIndex:customMArr.count];
    }
    
    NSMutableArray *pictureMArr = [TableViewData loadPictureData];
    for (PictureModel *model in pictureMArr) {
        
        CustomModel *customModel = [[CustomModel alloc] init];
        
        customModel.title = [model.date substringFromIndex:9];
        customModel.content = [model.content substringFromIndex:12];
        customModel.picture = model.picture;
        customModel.customCellH = pictureListCellH;
        
        [customMArr insertObject:customModel atIndex:customMArr.count];
    }
    
    return customMArr;
}

@end
