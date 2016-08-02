//
//  AudioRecorder.m
//  Yueba
//
//  Created by qingyun on 16/7/26.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "AudioRecorder.h"
#import <AVFoundation/AVFoundation.h>



@interface AudioRecorder ()

@property (nonatomic, strong)AVAudioRecorder *recorder;//录音
@property (nonatomic, strong)NSString *filePath;//录音保存的路径

@property (nonatomic, strong)NSTimer *timer;//更新分贝


@end

@implementation AudioRecorder

-(void)prepareRecordWith:(NSString *)path{
    NSError *error;
    //配置录音环境,获取设备
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    
    //准备录音的参数
    NSDictionary *settings = @{AVFormatIDKey:@(kAudioFormatMPEG4AAC),
                               AVSampleRateKey:@16000,
                               AVNumberOfChannelsKey:@1};
    //初始化录音
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:path] settings:settings error:&error];
//    self.recorder.delegate = self;
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];//可以获取分贝
    
    //初始化timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updatePowerValue:) userInfo:nil repeats:YES];
    
    //开始录音
    [self.recorder record];
    
    
}
//暂停
-(void)pauseRecord{
    if (self.recorder.recording) {
        [self.recorder pause];
        
        //暂停timer,设置触发时间为以后
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

//继续录音
-(void)continueRecord{
    if (!self.recorder.recording) {
        [self.recorder record];
        
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

//结束录音
-(void)stopRecord{
    //计算录音时间
    NSTimeInterval time = self.recorder.currentTime;
    //防止录音时间过短,设置最短时间为一秒
    self.currentTimeInterval = time < 1 ? 1 : time;
    
    [self.recorder stop];
    
    //让timer失效
    [self.timer invalidate];
    self.timer = nil;
    
    //恢复其它被打断的录音
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    
}


-(void)cancel{
    [self.recorder stop];
    
    //让timer失效
    [self.timer invalidate];
    self.timer = nil;
    
    //恢复其它被打断的录音
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    
    //删除文件
    [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:nil];
    
}

-(void)updatePowerValue:(NSTimer *)timer{
    //计算录音的分贝
    
    [self.recorder updateMeters];
    _currentTimeInterval = self.recorder.currentTime;
    CGFloat peakPower = [_recorder averagePowerForChannel:0];
    double alpha = 0.015;
    double peakPowerForChannel = pow(10, (alpha * peakPower));//计算出分贝
    NSLog(@"分贝%f", peakPowerForChannel);
    
    self.updatePower(peakPowerForChannel);
    
}


@end
