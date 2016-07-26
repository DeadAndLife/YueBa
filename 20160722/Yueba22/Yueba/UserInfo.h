//
//  UserInfo.h
//  Yueba
//
//  Created by qingyun on 16/7/19.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

//根据从网上获取的字典,转化为model对象,保存到数据库中,userid不重复
+(instancetype)createdUserInfoWithDict:(NSDictionary *)info;

//数据库中是否已经包含了这个userId
+(BOOL)isContentUserId:(NSString *)userId;

//查找所有好友
+(NSArray *)friendList;
+(NSArray *)updateFriendListWithDictList:(NSArray *)dictList;

@end

NS_ASSUME_NONNULL_END

#import "UserInfo+CoreDataProperties.h"
