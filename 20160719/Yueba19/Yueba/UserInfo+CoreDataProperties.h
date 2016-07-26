//
//  UserInfo+CoreDataProperties.h
//  Yueba
//
//  Created by qingyun on 16/7/19.
//  Copyright © 2016年 QingYun. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *gender;

@end

NS_ASSUME_NONNULL_END
