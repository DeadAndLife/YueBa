//
//  MessageManager.m
//  Yueba
//
//  Created by qingyun on 16/7/21.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "MessageManager.h"
#import "QYAccount.h"

@interface MessageManager ()<AVIMClientDelegate>

@end

@implementation MessageManager

+(instancetype)sharemessageManager{
    static MessageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MessageManager alloc] init];
    });
    return manager;
}

-(AVIMClient *)clint{
    if (_clint) {
        return _clint;
    }
    
    _clint = [[AVIMClient alloc] initWithClientId:[QYAccount shareAccount].userId];
    _clint.delegate = self;
    return _clint;
}

#pragma mark - avclint receive message

-(void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message{
    NSLog(@"message:%@",message);
}

-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    NSLog(@"type message:%@",message);
    [self.delegate conversation:conversation didReceiveTypedMessage:message];
}

@end
