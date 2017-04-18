//
//  TextListViewController.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/2.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "TextListViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "TextModel.h"
#import "TextListTableViewCell.h"
#import "TextEditViewController.h"
#import "TextPostViewController.h"
#import "SpeechViewController.h"
#import "RecorderViewController.h"

@interface TextListViewController ()<UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate>

//录音器
@property (nonatomic, strong)AVAudioRecorder *recorder;
//播放器
@property (nonatomic, strong)AVAudioPlayer *player;
//录音状态(是否录音)
@property (nonatomic, assign)BOOL isRecoding;
//录音存储路径
@property (nonatomic, strong)NSString *tmpFile;
//录音存储时间
@property (nonatomic, strong)NSString *tmpTitle;
@end

@implementation TextListViewController

static NSString *textList_cell = @"textList_cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self createTable];
    
    [self setupSession];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestData];
    [self selectTable];
    
}

- (void)setupNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(gotoEdit)];
    
    //处理图片
    UIImage *oldImg = [UIImage imageNamed:@"recorder"];
    UIGraphicsBeginImageContext(CGSizeMake(iconW, iconW));
    [oldImg drawInRect:CGRectMake(0, 0, iconW, iconW)];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIBarButtonItem *gotoPostBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(gotoPost)];
    UIBarButtonItem *gotoRecorderBtn = [[UIBarButtonItem alloc] initWithImage:[newImg  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(startRecorder)];

    self.navigationItem.rightBarButtonItems = @[gotoPostBtn, gotoRecorderBtn];
  
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)gotoEdit
{
    [self.navigationController pushViewController:[[TextEditViewController alloc] init] animated:YES];
    
}

- (void)gotoPost
{
    [self.navigationController pushViewController:[[TextPostViewController alloc] init] animated:YES];
}

- (void)gotoRecorder
{

    //[self.navigationController pushViewController:[[RecorderViewController alloc] init] animated:YES];
}

- (void)setupSession
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    [session setActive:YES error:nil];
    
    NSError *error;
    
    //判断后台有没有播放
    if (session == nil) {
        
        NSLog(@"Error creating sessing:%@", [error description]);
        
    } else {
        
        [session setActive:YES error:nil];
        
    }
}

- (void)startRecorder
{

    //判断当前状态是否为正在录音
    if (!self.isRecoding) {
    
        //状态改为录音状态
        self.isRecoding = YES;
        //录音按钮不可点
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
        //开始录音
        NSDictionary *recordSettings=[NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:AVAudioQualityMin],
                                      AVEncoderAudioQualityKey,
                                      [NSNumber numberWithInt:16],
                                      AVEncoderBitRateKey,
                                      [NSNumber numberWithInt:2],
                                      AVNumberOfChannelsKey,
                                      [NSNumber numberWithFloat:44100.0],
                                      AVSampleRateKey,
                                      nil];
        
        //初始化录音器
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *fileDate = [formatter stringFromDate:[NSDate date]];
        
        self.tmpFile = [NSString stringWithFormat:@"%@/%@.aiff", [FileManager dirLibCache], fileDate];
        self.tmpTitle = fileDate;
        
        NSError *error;
        
        self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:self.tmpFile] settings:recordSettings error:&error];
        self.recorder.delegate = self;
        
        [self.recorder prepareToRecord];
        [self.recorder record];
        
        _player = nil;
    }else{
        
        self.isRecoding = NO;
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        
        //停止录音
        [self.recorder stop];
        self.recorder = nil;
        
    }
    
    
}

- (void)startPlay:(NSString *)fileName
{
    
    NSError *error;
    
   //初始化播放器
    NSString *tmpPath = [NSString stringWithFormat:@"%@/%@.aiff", [FileManager dirLibCache], fileName];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:tmpPath] error:&error];
    self.player.delegate = self;
 
    if (self.player == nil) {
        
        NSLog(@"Error crenting player: %@", [error description]);
        
    }else{
        
        if([self.player isPlaying])
        {
            [self.player pause];
            
        }else{
            [self.player prepareToPlay];
            [self.player play];
        }
    }
}

- (void)saveToFile
{
    //生成配置文件textConfig.txt
    //每新建一个文档，会自动记录信息/项
    
    NSString *configPath = [NSString stringWithFormat:@"%@/textConfig.txt", [FileManager dirLib]];
    NSString *configContent = nil;
    
    if (![FileManager isExitsFile:configPath]) [FileManager writeFile:configPath content:@""];
    
    //新建项记录
    
    configContent = [NSString stringWithFormat:@"fileDate:%@%@fileTitle:%@%@fileContent:%@%@", self.tmpTitle, itemSpe, self.tmpTitle, itemSpe, nil, atricleSpe];
    
    
    //追加新项
    [FileManager updateFile:configPath newContent:configContent];
    
    //保存到数据库中
    NSDictionary *dataDic = @{@"date" : self.tmpTitle, @"title" : self.tmpTitle, @"allContent" : @"" };
    
    [[SQLiteManager sharedManager] insertData:dataDic intoTable:@
     "text"];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.tableListMArr ? self.tableListMArr.count: 0;
}

- (TextListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //检查表示图中是否存在闲置的cell
    TextListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textList_cell];
    if (!cell) {
        cell = [[TextListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textList_cell];
    }
    
    cell.textModel = self.tableListMArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return textListCellH;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextEditViewController *textEditVC = [[TextEditViewController alloc] init];
    
    textEditVC.textModel = self.tableListMArr[indexPath.row];
    
    if (textEditVC.textModel.allContent == nil) {//是存放音频的cell
        
        //播放音频
        [self startPlay:[textEditVC.textModel.date substringFromIndex:9]];
    
    }else{
        
        [self.navigationController pushViewController:textEditVC animated:YES];
    }
}

// 设置cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//设置编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后，进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        TextModel *textModel = self.tableListMArr[indexPath.row];
        
        //删除本地文件
        NSString *titleFormater = [textModel.date substringFromIndex:9];
        NSString *deleteFilePath = @"";
        
        if (textModel.allContent == nil) {
            
            deleteFilePath = [NSString stringWithFormat:@"%@/%@.aiff", [FileManager dirLibCache], titleFormater];
            
        }else{
            
            deleteFilePath = [NSString stringWithFormat:@"%@/%@.txt", [FileManager dirLibCache], titleFormater];
        }

        [FileManager deleteFile:deleteFilePath];
        
        //修改config文件
        NSString *configPath = [NSString stringWithFormat:@"%@/textConfig.txt", [FileManager dirLib]];
        NSString *configContent = [FileManager readFile:configPath];
        
        NSMutableArray *configMArr = [[NSMutableArray alloc] init];
        NSArray *configArr = [configContent componentsSeparatedByString:atricleSpe];
        for (int i = 0; i < configArr.count; i ++) {
            [configMArr addObject:configArr[i]];
        }
        [configMArr removeObjectAtIndex:indexPath.row];
        //根据一个数组连成一个新的字符串
        configContent = [configMArr componentsJoinedByString:atricleSpe];
        [FileManager writeFile:configPath content:configContent];
        
        //修改self.tableListMArr
        [self.tableListMArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        //对数据库进行修改
        NSString *wlStr = [NSString stringWithFormat:@"date = %@", titleFormater];
        [[SQLiteManager sharedManager] deleteDataFromTable:@"text" whereString:wlStr];
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
    self.tableListMArr = [TableViewData loadTextData];
    
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
    NSString *sql = @"create table if not exists text (id integer primary key autoincrement, date text, title text, allContent text)";

    [[SQLiteManager sharedManager] executeNonQuery:sql];
    
}

- (void)selectTable
{
    self.tableMArr = [[SQLiteManager sharedManager] executeQuery:@"select * from text"];
}

#pragma mark - AVAudioRecorderDelegate

// 当录音结束后调用
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    //保存到文件中
    [self saveToFile];
    
    //重新加载视图
    [self requestData];
    
}


#pragma mark - AVAudioPlayerDelegate

// 当播放结束后调用这个方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(flag)
    {
        ZLog(@"success");
    }
}

@end
