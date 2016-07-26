//
//  UserInfo.m
//  Yueba
//
//  Created by qingyun on 16/7/19.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "UserInfo.h"
#import "AppDelegate.h"

@implementation UserInfo

// Insert code here to add functionality to your managed object subclass

+(instancetype)createdUserInfoWithDict:(NSDictionary *)info{
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    //设置查询
    NSFetchRequest *fetchreq = [NSFetchRequest fetchRequestWithEntityName:@"UserInfo"];
    //谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@", info[@"userId"]];
    fetchreq.predicate = predicate;
    
    //执行查询
    NSArray *result = [app.managedObjectContext executeFetchRequest:fetchreq error:nil];
    //模型对象
    UserInfo *user;
    //如果存在userId,直接使用,如果不存在,创建新的
    if (result.count > 0) {
        user = result[0];
    }else{
        user  = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:app.managedObjectContext];
    }
    user.userId = [info[@"userId"] stringValue];
    user.gender = info[@"gender"];
    user.name = info[@"name"];
    
    //保存
    [app saveContext];
    return user;
}

+(BOOL)isContentUserId:(NSString *)userId{
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    //设置查询
    NSFetchRequest *fetchreq = [NSFetchRequest fetchRequestWithEntityName:@"UserInfo"];
    //谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@", userId];
    fetchreq.predicate = predicate;
    
    //执行查询
    NSArray *result = [app.managedObjectContext executeFetchRequest:fetchreq error:nil];
    
    return (result.count > 0);
    
}



@end
