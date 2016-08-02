//
//  VoiceRecordingView.m
//  Yueba
//
//  Created by qingyun on 16/7/26.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "VoiceRecordingView.h"

@implementation VoiceRecordingView

-(void)setPeakPow:(CGFloat)peakPow{
    for (int i = 0; i < 8; i++) {
        float j = (i + 1)/10.f;//音量的档次,每个档次差0.1
        if (peakPow <=j&& peakPow > j - 0.1) {
            NSString *imageName = [NSString stringWithFormat:@"RecordingSignal00%d", i +1];
            _powerView.image = [UIImage imageNamed:imageName];
        }
        
    }
}

@end
