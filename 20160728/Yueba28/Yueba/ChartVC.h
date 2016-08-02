//
//  ChartVC.h
//  Yueba
//
//  Created by qingyun on 16/7/21.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"


@interface ChartVC : UIViewController

@property (nonatomic, strong)UserInfo *friendUser;//聊天的对象
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong)UIImageView *seletedImageView;//点击选择的图片

@end
