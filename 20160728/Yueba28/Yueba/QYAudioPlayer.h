//
//  QYAudioPlayer.h
//  Yueba
//
//  Created by qingyun on 16/7/26.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYAudioPlayer : NSObject

+(instancetype)sharePlaer;

//播放声音
-(void)playAudioWithData:(NSData *)data;
//暂停
-(void)pausePlay;
//停止
-(void)stopPlay;


@end
