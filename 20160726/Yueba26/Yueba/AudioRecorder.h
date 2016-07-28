//
//  AudioRecorder.h
//  Yueba
//
//  Created by qingyun on 16/7/26.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//更新分贝的block;
typedef void (^UpdatePowerValue) (CGFloat power);

@interface AudioRecorder : NSObject

@property (nonatomic)NSTimeInterval currentTimeInterval;//录音时长

@property (nonatomic, copy)UpdatePowerValue updatePower;

//准备开始录音
-(void)prepareRecordWith:(NSString *)path;

//暂停
-(void)pauseRecord;
//继续录音
-(void)continueRecord;
//结束录音
-(void)stopRecord;
//取消录音
-(void)cancel;

@end
