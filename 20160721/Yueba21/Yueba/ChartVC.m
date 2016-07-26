//
//  ChartVC.m
//  Yueba
//
//  Created by qingyun on 16/7/21.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "ChartVC.h"
#import "MessageManager.h"
#import "QYAccount.h"

@interface ChartVC ()

@property (nonatomic, strong)AVIMConversation *comersation;

@end

@implementation ChartVC

-(void)viewDidLoad{
    self.title = self.friendUser.name;
    
}

-(void)creatConver{
    AVIMClient *clint = [MessageManager sharemessageManager].clint;
    
    //会话名字
    NSString *name = [NSString stringWithFormat:@"%@ 和 %@", [QYAccount shareAccount].name, _friendUser.name];
    //会话的参与用户
    NSArray *ids = @[[QYAccount shareAccount].userId, _friendUser.userId];
    
    
    if (clint.status == AVIMClientStatusOpened) {
        [clint createConversationWithName:name clientIds:ids attributes:nil options:AVIMConversationOptionNone | AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
            //创建会话成功
        }];
    }else{
        [clint openWithCallback:^(BOOL succeeded, NSError *error) {
            [clint createConversationWithName:name clientIds:ids attributes:nil options:AVIMConversationOptionNone | AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
                //创建会话成功
            }];
        }];
    }
    
}

@end
