//
//  QYUserInfo.m
//  Yueba
//
//  Created by qingyun on 16/7/18.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYUserInfo.h"

@implementation QYUserInfo

-(instancetype)initWithDictInfo:(NSDictionary *)info{
    if (self = [super init]) {
        self.userId = [info[@"userId"] stringValue];
        self.gender = info[@"gender"];
        self.name = info[@"name"];
    }
    return self;
}

@end
