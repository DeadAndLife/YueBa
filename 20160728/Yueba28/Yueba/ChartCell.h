//
//  ChartCell.h
//  Yueba
//
//  Created by qingyun on 16/7/22.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVIMTypedMessage;
@interface ChartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UILabel *messageText;
@property (weak, nonatomic) IBOutlet UIView *voiceBgView;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImage;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

-(void)bandingMessage:(AVIMTypedMessage *)message;

//播放声音的动画的开始和结束
-(void)startanimation;
-(void)stopAnimation;

-(BOOL)isTapedInContent:(UITapGestureRecognizer *)tap;

@end
