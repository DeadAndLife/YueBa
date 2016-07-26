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

+(NSArray *)friendList{
    //查询
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserInfo"];
    //添加好友的时间,降序排列
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    //设置谓词,是朋友
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFriend = %@", @1];
    request.sortDescriptors = @[sort];
    request.predicate = predicate;
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSArray *friendList = [app.managedObjectContext executeFetchRequest:request error:nil];
    
    return friendList;
    
}

+(NSArray *)updateFriendListWithDictList:(NSArray *)dictList{
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    //本地保存的好友信息
    NSArray *friendList = [UserInfo friendList];
    
    //转变为可变数组,用于筛选多余的
    NSMutableArray *friendListMu = [NSMutableArray arrayWithArray:friendList];
    
    for (NSDictionary *infoDict in dictList) {
        NSString *userId = infoDict[@"userId"];
        
        //遍历查找网络请求的用户信息,本地是否存在
        int i = 0;
        for (UserInfo *user in friendList) {
            if (userId == user.userId) {
                //从可变数组中移走
                [friendListMu removeObject:user];
                break;
            }
            i++;
        }
        
        if (i>= friendList.count) {
            //遍历了每一个对象,则证明不存
            //插入新的记录
            
            UserInfo *userInfo = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:app.managedObjectContext];
            userInfo.name = infoDict[@"name"];
            userInfo.gender = infoDict[@"gender"];
            userInfo.userId = [infoDict[@"userId"] stringValue];
            userInfo.createdAt = [NSDate dateWithTimeIntervalSince1970:[infoDict[@"createdAt"] floatValue]];
            userInfo.isFriend = @YES;
        }
        
    }
    //friendListMu中剩余的就是要删除(多余的,服务器不存在的)
    
    for (UserInfo *user in friendListMu) {
        user.isFriend = @NO;
    }
    
    
    //同步保存信息到数据库
    [app saveContext];
    
    return [UserInfo friendList];
    
}

@end
