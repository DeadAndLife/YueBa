//
//  QYHTTPManager.h
//  Yueba
//
//  Created by qingyun on 16/7/14.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void(^QYHTTPSessionManagerCompletionHandle) (id responseObject, NSURLSessionTask *task, NSError *error);

@interface QYHTTPManager : AFHTTPSessionManager

//配置baseurl
+(instancetype)qyManager;

//封装网络get请求,成功的block和失败的,合二为一
-(NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle;

//封装网络POST请求,成功的block和失败的,合二为一
-(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle;

//请求短信验证码
-(NSURLSessionDataTask *)sendSMSCode:(NSString *)phoneNumber CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle;

//创建账号
-(NSURLSessionDataTask *)CreatedAccount:(NSString *)phoneNumber
                                SMSCode:(NSString *)code
                                    Pwd:(NSString *)pwd
                    CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle;

//登录账号
-(NSURLSessionDataTask *)loginAccount:(NSString *)phoneNumber
                                    Pwd:(NSString *)pwd
                       CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle;

//提交用户信息,用字典保存参数
-(NSURLSessionDataTask *)uploadUserInfo:(NSDictionary *)userInfo
                     CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle;

//批量获取用户信息
-(NSURLSessionDataTask *)getUserInfoWithUserIds:(NSArray *)userIds
                          Gender:(NSString *)gender
                       CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle;

@end
