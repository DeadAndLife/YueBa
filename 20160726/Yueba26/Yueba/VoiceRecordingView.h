//
//  VoiceRecordingView.h
//  Yueba
//
//  Created by qingyun on 16/7/26.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceRecordingView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *powerView;//指示分贝的图标

@property (nonatomic)CGFloat peakPow;//说话的音量;
@end
