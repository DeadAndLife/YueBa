//
//  QYPhotoBrowser.h
//  Yueba
//
//  Created by qingyun on 16/7/28.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYPhotoBrowser : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic)CGRect originFrame;

@end
