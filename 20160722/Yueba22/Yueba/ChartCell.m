//
//  ChartCell.m
//  Yueba
//
//  Created by qingyun on 16/7/22.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "ChartCell.h"
#import <AVOSCloudIM.h>

@implementation ChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIImage *image;
    if ([self.reuseIdentifier isEqualToString:@"chartcellleft"]) {
        //设置左边的bgimage
        image = [UIImage imageNamed:@"chat_bubble_gray"];
    }else {
        image = [UIImage imageNamed:@"chat_bubble_red"];
    }
    
    //设置image拉伸
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(17, 23, 18, 24)];
    self.bgImage.image = image;
    
}

-(void)bandingMessage:(AVIMTypedMessage *)message{
    //根据message,绑定内容
    if ([message isKindOfClass:[AVIMTextMessage class]]) {
        self.messageText.text = message.text;
    }
    
    //设置背景素材
    
}

@end
