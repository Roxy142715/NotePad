//
//  PaletteViewController.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/18.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "PaletteViewController.h"
#import "PaletteView.h"

@interface PaletteViewController ()

@property (nonatomic, strong) PaletteView *paletteView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation PaletteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    [self setPaletteView];
    [self setOperations];
}

- (void)setupNav
{
    self.navigationItem.title = @"画板记事";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存并返回" style:UIBarButtonItemStylePlain target:self action:@selector(saveAndBack)];
}

- (void)setPaletteView
{
    PaletteView *paletteView = [[PaletteView alloc] init];
    [self.view addSubview:paletteView];
    self.paletteView = paletteView;
    
}

- (void)setOperations
{
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    clearBtn.frame = CGRectMake(ZScreenW * 0.2, btnMarginY, 100, btnH);
    [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBtn];
    
    UIButton *revokeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    revokeBtn.frame = CGRectMake(ZScreenW * 0.6, btnMarginY, 100, btnH);
    [revokeBtn setTitle:@"撤销" forState:UIControlStateNormal];
    [revokeBtn addTarget:self action:@selector(revoke) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:revokeBtn];
    
}

- (void)revoke
{
    [self.paletteView.lineMArr removeLastObject];
    [self.paletteView setNeedsDisplay];
    
}

- (void)clear
{
    [self.paletteView.lineMArr removeAllObjects];
    [self.paletteView setNeedsDisplay];
    
}
- (void)viewDidLayoutSubviews
{
    _paletteView.frame = CGRectMake(0, btnH + btnMarginY, ZScreenW, ZScreenH - btnH - btnMarginY);
}

//保存当前画板上的内容
- (void)saveAndBack
{
    //创建一个基于位图的图形上下文
    UIGraphicsBeginImageContextWithOptions(_paletteView.bounds.size, YES, 0);
    [_paletteView drawViewHierarchyInRect:_paletteView.bounds afterScreenUpdates:YES];
    //返回一个基于当前图形上下文的图片
    UIImage *tempImg = UIGraphicsGetImageFromCurrentImageContext();
    _image = tempImg;
    //将图片保存到图库
    UIImageWriteToSavedPhotosAlbum(tempImg, nil, nil, nil);
    //关闭上下文
    UIGraphicsEndImageContext();
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self saveToFile];
}

- (void)saveToFile
{
    NSString *fileDate = @"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    fileDate = [formatter stringFromDate:[NSDate date]];
    
    //将图片转成NSData
    NSData *imgData = UIImageJPEGRepresentation(self.image, 1.0);
    
    //保存图片
    NSString *cachePath = [FileManager dirLibCache];
    NSString *picturePath =[NSString stringWithFormat:@"%@/%@.png", cachePath, fileDate];
    [imgData writeToFile:picturePath atomically:YES];
    
    //生成配置文件pictureConfig.txt
    
    NSString *configPath = [NSString stringWithFormat:@"%@/pictureConfig.txt", [FileManager dirLib]];
    NSString *configContent = @"";
    
    if (![FileManager isExitsFile:configPath]) [FileManager writeFile:configPath content:@""];
    
    configContent = [NSString stringWithFormat:@"fileDate:%@%@filePath:%@.png%@fileContent:%@%@", fileDate, itemSpe, fileDate, itemSpe, nil, atricleSpe];
    
    //追加新项
    [FileManager updateFile:configPath newContent:configContent];
    
   
    //保存到数据库中
    NSDictionary *dataDic = @{@"date" : fileDate, @"content" : @"", @"picture" : fileDate };
    
    [[SQLiteManager sharedManager] insertData:dataDic intoTable:@
     "picture"];
    
}
@end
