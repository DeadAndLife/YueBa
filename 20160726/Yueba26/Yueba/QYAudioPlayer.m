//
//  QYAudioPlayer.m
//  Yueba
//
//  Created by qingyun on 16/7/26.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface QYAudioPlayer ()<AVAudioPlayerDelegate>

@property (nonatomic, strong)AVAudioPlayer *audioPlayer;

@end

@implementation QYAudioPlayer

+(instancetype)sharePlaer{
    static QYAudioPlayer *player;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[QYAudioPlayer alloc] init];
    });
    
    return player;
}

-(void)playAudioWithData:(NSData *)data{
    //设置使用扬声器
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    //清空播放器
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    if (error) {
        NSLog(@"播放错误");
    }
    _audioPlayer.delegate = self;
    [_audioPlayer play];
    [self configProximityMonitorEnableState:YES];
    
}

-(void)stopPlay{
    [_audioPlayer stop];
    
    //唤醒其他被打断的播放,
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    [self configProximityMonitorEnableState:NO];
    
}

-(void)pausePlay{
    [_audioPlayer pause];

}

//开启或关闭距离传感器
-(void)configProximityMonitorEnableState:(BOOL)enabled{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:enabled];
    if (enabled) {
        //添加距离感应器状态改变的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStatueChange:) name:UIDeviceProximityStateDidChangeNotification
                                                   object:nil];
    }else{
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
}

//选择使用听筒还是扬声器播放声音
-(void)proximityStatueChange:(NSNotification *)noti{
    if ([UIDevice currentDevice].proximityState) {
        //距离感应器接收到感应
        //设置听筒播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }else{
        //设置话筒播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}


#pragma mark - audio delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self configProximityMonitorEnableState:NO];
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    [self configProximityMonitorEnableState:NO];
}

@end
