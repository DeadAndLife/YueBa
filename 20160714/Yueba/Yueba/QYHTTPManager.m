//
//  QYHTTPManager.m
//  Yueba
//
//  Created by qingyun on 16/7/14.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYHTTPManager.h"
#import "Common.h"

@implementation QYHTTPManager

+(instancetype)qyManager{
    QYHTTPManager *manager = [[QYHTTPManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    return manager;
}


-(NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle{
    
    return [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandle(responseObject, task, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandle(nil, task, error);
    }];
    
}

-(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle{
    return [self POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandle(responseObject, task, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandle(nil, task, error);
    }];
}

-(NSURLSessionDataTask *)sendSMSCode:(NSString *)phoneNumber CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle{
    
    //构造参数
    NSDictionary *params = @{@"telephone":phoneNumber};
    
    return [self POST:kSMSCodeAPI parameters:params CompletionHandle:^(id responseObject, NSURLSessionTask *task, NSError *error) {
        completionHandle(responseObject, task, error);
    }];
}

-(NSURLSessionDataTask *)CreatedAccount:(NSString *)phoneNumber SMSCode:(NSString *)code Pwd:(NSString *)pwd CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle{
    
    //构造参数
    NSDictionary *params = @{@"telephone":phoneNumber, @"msmCode":code, @"password":pwd};
    
    return [self POST:kCreatedAccountAPI parameters:params CompletionHandle:^(id responseObject, NSURLSessionTask *task, NSError *error) {
        completionHandle(responseObject, task, error);
    }];
    
    
}

@end
