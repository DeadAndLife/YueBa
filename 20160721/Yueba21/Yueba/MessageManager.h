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

@interface MessageManager : NSObject

@property (nonatomic, strong)AVIMClient *clint;


+(instancetype)sharemessageManager;

@end
