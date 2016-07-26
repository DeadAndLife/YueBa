//
//  MessageManager.h
//  Yueba
//
//  Created by qingyun on 16/7/21.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>
#import <AVOSCloudIM.h>

@protocol MessageManagerDelegate <NSObject>

//收到消息,通知Delegate
-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message;

@end

@interface MessageManager : NSObject

@property (nonatomic, strong)AVIMClient *clint;
@property (nonatomic, weak)id<MessageManagerDelegate> delegate;

+(instancetype)sharemessageManager;

@end
