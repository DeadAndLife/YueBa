//
//  Card+CoreDataProperties.h
//  PersonCard
//
//  Created by qingyun on 16/7/19.
//  Copyright © 2016年 QingYun. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface Card (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *no;
@property (nullable, nonatomic, retain) NSManagedObject *person;

@end

NS_ASSUME_NONNULL_END
