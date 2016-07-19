//
//  QYUserInfo.h
//  Yueba
//
//  Created by qingyun on 16/7/18.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYUserInfo : NSObject

@property (nonatomic , strong)NSString *userId;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *gender;
@property (nonatomic, strong)NSString *iconURL;

//根据网络请求的信息,初始化model
-(instancetype)initWithDictInfo:(NSDictionary *)info;

@end
