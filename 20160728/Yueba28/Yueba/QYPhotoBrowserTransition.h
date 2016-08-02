//
//  QYPhotoBrowserTransition.h
//  Yueba
//
//  Created by qingyun on 16/7/28.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//转场动画对象
@interface QYPhotoBrowserTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic)BOOL isShow;//显示或者消失


@end
