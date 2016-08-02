//
//  FunctionView.h
//  Yueba
//
//  Created by qingyun on 16/7/23.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FunctionDelegate <NSObject>

//根据索引执行相应的操作
-(void)selectAction:(NSInteger)actionIndex;

@end

@interface FunctionView : UIView
@property (weak, nonatomic) IBOutlet UIButton *selectImage;
@property (weak, nonatomic) IBOutlet UIButton *phoneImage;
@property (weak, nonatomic) IBOutlet UIButton *shareLocation;

@property (nonatomic, weak)id<FunctionDelegate> delegate;


- (IBAction)buttonPress:(id)sender;


@end
