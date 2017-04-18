//
//  MainShowTableViewController.m
//  NotePad
//
//  Created by 陈晓磊 on 17/4/6.
//  Copyright © 2017年 ZXX. All rights reserved.
//

#import "MainShowTableViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "CustomModel.h"
#import "MainShowTableViewCell.h"

@interface MainShowTableViewController ()<UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate>
//播放器
@property (nonatomic, strong)AVAudioPlayer *player;

@end

@implementation MainShowTableViewController

static NSString *custom_cell = @"custom_cell";

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"搜索结果";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame = CGRectMake(0, cellMargin * 4, ZScreenW, 30);
    [self.tableView addSubview:titleLab];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor blueColor]];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(ZScreenW * 0.35, ZScreenH * 0.8, 100, 30);
    [self.view addSubview:backBtn];
    self.backBtn = backBtn;
    
    [self setupSession];
    
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (MainShowTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:custom_cell];
    
    if (!cell) {
        cell = [[MainShowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:custom_cell];
    }
    cell.customModel = self.showModel;
    [cell.voiceBtn addTarget:self action:@selector(startPlay) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.showModel.customCellH + cellMargin * 2;
}

- (void)startPlay
{
    //播放音频
    [self startPlay:self.showModel.title];
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZLog(@"sdfhjk");
    //播放音频
    [self startPlay:self.showModel.title];

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
