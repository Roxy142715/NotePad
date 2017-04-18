//
//  RecorderViewController.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/27.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "RecorderViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface RecorderViewController ()<AVAudioRecorderDelegate, AVAudioPlayerDelegate>

//录音存储路径
@property (nonatomic, strong)NSString *tmpFile;
//录音器
@property (nonatomic, strong)AVAudioRecorder *recorder;
//播放器
@property (nonatomic, strong)AVAudioPlayer *player;
//录音状态(是否录音)
@property (nonatomic, assign)BOOL isRecoding;

@end

@implementation RecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNav];
    [self setupView];
    [self setupRecorder];

}

- (void)setNav
{
    self.navigationItem.title = @"语音记事";
    
   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存并返回" style:UIBarButtonItemStylePlain target:self action:@selector(saveAndBack)];
}

- (void)setupView
{
    UIButton *recorderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recorderBtn.frame = CGRectMake(cellMargin * 2, 100, 100, 30);
    [recorderBtn setTitle:@"录音" forState:UIControlStateNormal];
    recorderBtn.backgroundColor = [UIColor brownColor];
    [recorderBtn addTarget:self action:@selector(startRecoder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recorderBtn];
    self.recordBtn = recorderBtn;
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(cellMargin * 2 + 130, 100, 100, 30);
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    playBtn.backgroundColor = [UIColor brownColor];
    [playBtn addTarget:self action:@selector(startPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    self.playBtn = playBtn;
    
}

- (void)setupRecorder
{
    //刚打开的时候录音状态为不录音
    self.isRecoding = NO;
    
    //播放按钮不能被点击
    [self.playBtn setEnabled:NO];
    //播放按钮设置成半透明
    self.playBtn.titleLabel.alpha = 0.5;
    
    //创建临时文件来存放录音文件
    //存放录音文件
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *fileDate = [formatter stringFromDate:[NSDate date]];
    
    NSString *cachePath = [FileManager dirLibCache];
    self.tmpFile = [NSString stringWithFormat:@"%@/%@.aiff", cachePath, fileDate];

    //设置后台播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    //判断后台有没有播放
    if (session == nil) {
        
        NSLog(@"Error creating sessing:%@", [sessionError description]);
        
    } else {
        
        [session setActive:YES error:nil];
        
    }
    
}

-(void)startRecoder
{
    
    //判断当录音状态为不录音的时候
    if (!self.isRecoding) {
        //将录音状态变为录音
        self.isRecoding = YES;
        
        //将录音按钮变为停止
        [self.recordBtn setTitle:@"停止" forState:UIControlStateNormal];
        
        //播放按钮不能被点击
        [self.playBtn setEnabled:NO];
        self.playBtn.titleLabel.alpha = 0.5;
        
        //开始录音,将所获取到得录音存到文件里
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
        
        self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:_tmpFile] settings:recordSettings error:nil];
        
        self.recorder.delegate = self;
        
        //准备记录录音
        [_recorder prepareToRecord];
        
        //启动或者恢复记录的录音文件
        [_recorder record];
        
        _player = nil;
        
    } else {
        
        //录音状态 点击录音按钮 停止录音
        self.isRecoding = NO;
        [self.recordBtn setTitle:@"录音" forState:UIControlStateNormal];
        
        //录音停止的时候,播放按钮可以点击
        [self.playBtn setEnabled:YES];
        [self.playBtn.titleLabel setAlpha:1];
        
        //停止录音
        [_recorder stop];
        
        _recorder = nil;
      
        NSError *playError;
        //self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:_tmpFile]  error:&playError];
        
        //当播放录音为空, 打印错误信息
        if (self.player == nil) {
            NSLog(@"Error crenting player: %@", [playError description]);
        }
        self.player.delegate = self;
        
    }
    
}

- (void)startPlay
{
    //判断是否正在播放,如果正在播放
    if ([self.player isPlaying]) {
    
        [_player pause];
        
        [self.playBtn setTitle:@"播放" forState:UIControlStateNormal];
        
    } else {
    
        [_player play];
        
        [self.playBtn setTitle:@"暂停" forState:UIControlStateNormal];
        
    }
}

- (void)saveToFile
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *fileDate = [formatter stringFromDate:[NSDate date]];

    //生成配置文件textConfig.txt
    //每新建一个文档，会自动记录信息/项
    
    NSString *configPath = [NSString stringWithFormat:@"%@/textConfig.txt", [FileManager dirLib]];
    NSString *configContent = nil;
    
    if (![FileManager isExitsFile:configPath]) [FileManager writeFile:configPath content:@""];
    
    //新建项记录
    
    configContent = [NSString stringWithFormat:@"fileDate:%@%@fileTitle:%@%@fileContent:%@%@", fileDate, itemSpe, fileDate, itemSpe, nil, atricleSpe];
    
    
    //追加新项
    [FileManager updateFile:configPath newContent:configContent];
    
    //保存到数据库中
    NSDictionary *dataDic = @{@"date" : fileDate, @"title" : fileDate, @"allContent" : @"" };
    
    [[SQLiteManager sharedManager] insertData:dataDic intoTable:@
     "text"];
    
}

#pragma mark - AVAudioRecorderDelegate

// 当录音结束后调用
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    //保存到文件中
    [self saveToFile];
    
    //录音后返回
}


#pragma mark - AVAudioPlayerDelegate

// 当播放结束后调用这个方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //按钮标题变为播放
    [self.playBtn setTitle:@"播放" forState:UIControlStateNormal];
}
@end
