//
//  SpeechViewController.m
//  NotePad
//
//  Created by 陈晓磊 on 17/3/19.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "SpeechViewController.h"

#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>

@interface SpeechViewController ()<SFSpeechRecognitionTaskDelegate, AVAudioRecorderDelegate>

//添加一些属性，便于开始结束释放

// 语音识别操作类 识别器
@property(nonatomic,strong)SFSpeechRecognizer *recognizer;
// 通过音频流来创建语音识别请求
@property(nonatomic,strong)SFSpeechAudioBufferRecognitionRequest *recognizerRequest;
// 语音识别任务
@property(nonatomic,strong)SFSpeechRecognitionTask *recognizerTask;
// 音频节点管理类 录音引擎
@property(nonatomic,strong)AVAudioEngine *audioEngine;
// 输入的音频块
@property(nonatomic,strong)AVAudioInputNode *audioInputNode;

@end

@implementation SpeechViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNav];
    [self setView];
    
    //请求使用权限
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        // 对结果枚举的判断 用户授权
        if(status != SFSpeechRecognizerAuthorizationStatusAuthorized){
            
            //不给权限直接退出
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }];
    
}

- (void)setNav
{
    self.navigationItem.title = @"语音记事";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存并返回" style:UIBarButtonItemStylePlain target:self action:@selector(saveAndBack)];
}

- (void)saveAndBack
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *fileDate = [formatter stringFromDate:[NSDate date]];
    NSString *fileTitle = fileDate;
    
    NSString *cachePath = [FileManager dirLibCache];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.txt", cachePath, fileDate];
    
    BOOL isWriteSuccess = [FileManager writeFile:filePath content:self.contentTextView.text];
    
    //生成配置文件textConfig.txt
    //每新建一个文档，会自动记录信息项
    
    if (isWriteSuccess) {
        NSString *configPath = [NSString stringWithFormat:@"%@/textConfig.txt", [FileManager dirLib]];
        NSString *configContent = nil;
        
        if (![FileManager isExitsFile:configPath]) [FileManager writeFile:configPath content:@""];
        
        //新建项记录
        if ([self.contentTextView.text length] > 20) {
            configContent = [NSString stringWithFormat:@"fileDate:%@%@fileTitle:%@%@fileContent:%@%@", fileDate, itemSpe, fileTitle, itemSpe, [self.contentTextView.text substringToIndex:20], atricleSpe];
        }else{
            configContent = [NSString stringWithFormat:@"fileDate:%@%@fileTitle:%@%@fileContent:%@%@", fileDate, itemSpe, fileTitle, itemSpe, self.contentTextView.text, atricleSpe];
        }
        
        //追加新项
        [FileManager updateFile:configPath newContent:configContent];
    }
    
    //保存到数据库中
    NSDictionary *dataDic = @{@"date" : fileDate, @"title" : fileTitle, @"allContent" : self.contentTextView.text };
    
    [[SQLiteManager sharedManager] insertData:dataDic intoTable:@
     "text"];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setView
{
    UIButton *startBtn = [[UIButton alloc] init];
    [startBtn.titleLabel setTintColor:[UIColor orangeColor]];
    startBtn.titleLabel.font = [UIFont fontWithName:globalFont size:20];
    [startBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [startBtn setTitle:@"开始录音" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startRecoder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    self.startBtn = startBtn;
    
    UIButton *stopBtn = [[UIButton alloc] init];
    [stopBtn.titleLabel setTintColor:[UIColor orangeColor]];
    stopBtn.titleLabel.font = [UIFont fontWithName:globalFont size:20];
    [stopBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [stopBtn setTitle:@"停止录音" forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(stopRecoder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    self.stopBtn = stopBtn;
    
    UITextView *contentTextView = [[UITextView alloc] init];
    contentTextView.textAlignment = NSTextAlignmentLeft;
    contentTextView.editable = NO;
    [self.view addSubview:contentTextView];
    self.contentTextView = contentTextView;
    
}

- (void)viewDidLayoutSubviews
{
    self.contentTextView.frame = CGRectMake(cellMargin, 70, ZScreenW - cellMargin * 2, ZScreenH - 250);
    self.startBtn.frame = CGRectMake(ZScreenW * 0.2, self.contentTextView.height + self.contentTextView.y, 100, 100);
    self.stopBtn.frame = CGRectMake(ZScreenW * 0.6, self.contentTextView.height + self.contentTextView.y, 100, 100);
}

// AVAudioRecorder实现录音
// SFSpeechRecognizer实现语音识别
- (void)startRecoder
{
    //实例化识别器 设备识别语言为中文
    self.recognizer = [[SFSpeechRecognizer alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    
    //实例化音频引擎 设置
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.audioInputNode = [self.audioEngine inputNode];
    
    if (_recognizerTask != nil) {
        
        [_recognizerTask cancel];
        _recognizerTask = nil;
    }
    
    //音频会话
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [audioSession setMode:AVAudioSessionModeMeasurement error:nil];
    [audioSession setActive:true error:nil];

    //参数设置 最优语音质量
    self.recognizerRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    self.recognizerRequest.shouldReportPartialResults = true;
    
    __weak SpeechViewController *weakSelf = self;
    
    //开始识别任务
    self.recognizerTask = [self.recognizer recognitionTaskWithRequest:self.recognizerRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        
        if (error) {
            
            weakSelf.contentTextView.text = error.localizedDescription;
            
        }
        
        if (result) {
        
            weakSelf.contentTextView.text = result.bestTranscription.formattedString;
        }
        
    }];
    
    // 监听一个标识位并拼接流文件
    AVAudioFormat *format =[self.audioInputNode outputFormatForBus:0];
    [self.audioInputNode installTapOnBus:0 bufferSize:1024 format:format block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [weakSelf.recognizerRequest appendAudioPCMBuffer:buffer];
    }];
    
    //准备并启动引擎
    [self.audioEngine prepare];
    NSError *error = nil;
    
    if (![self.audioEngine startAndReturnError:&error]) {
        NSLog(@"%@", error.userInfo);
    }
    self.contentTextView.text = @"等待命令中...";
}

- (void)stopRecoder
{
    [self.audioEngine stop];
    [self.audioInputNode removeTapOnBus:0];
    
    self.recognizerRequest = nil;
    self.recognizerTask = nil;
    
}

@end
