//
//  ViewController.m
//  SiderslipVC
//
//  Created by qingyun on 16/7/15.
//  Copyright © 2016年 QingYun. All rights reserved.
//




#import "SiderslipVC.h"

//控制器的位置
typedef enum : NSUInteger {
    kFrontPositionLeft,
    kFrontPositionRight,
} FrontPosition;

@interface SiderslipVC ()

@property (nonatomic, strong)UIViewController *rearVC;
@property (nonatomic, strong)UIViewController *frontVC;
@property (nonatomic)FrontPosition frontVCPosition;
@property (nonatomic)CGFloat rightWidth;
@property (nonatomic, strong)UITapGestureRecognizer *tap;//点击手势
@property (nonatomic, strong)UIPanGestureRecognizer *pan;//滑动

@end

@implementation SiderslipVC

-(instancetype)initWithRearVC:(UIViewController *)rearVC FrontVC:(UIViewController *)frontVC{
    if (self = [super init]) {
        _frontVC = frontVC;
        _rearVC = rearVC;
        
        [self addChildViewController:rearVC];
        [self addChildViewController:frontVC];

        
    }
    return self;
}

-(void)loadView{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.frontVCPosition = kFrontPositionRight;
    self.rightWidth = 60.f;
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    
    //显示内容
    [self addchildVC];
    
}



//view layout完成,修改子视图的位置
-(void)viewDidLayoutSubviews{
    //布局子视图
    [self layoutSubView];
}

//添加View
-(void)addchildVC{
    //将子控制器,的View添加到self.view
    [self.view addSubview:self.rearVC.view];
    [self.view addSubview:self.frontVC.view];
    
    //添加手势
    [self.frontVC.view addGestureRecognizer:self.tap];
    [self.frontVC.view addGestureRecognizer:self.pan];
}

//布局View,根据控制器的位置
-(void)layoutSubView{
    self.rearVC.view.frame = self.view.bounds;
    if (self.frontVCPosition == kFrontPositionLeft) {
        self.frontVC.view.frame = self.view.bounds;
    }else{
        CGFloat left = self.view.frame.size.width - self.rightWidth;
        self.frontVC.view.frame = CGRectOffset(self.view.bounds, left, 0);
    }
    
}

//手势的事件
-(void)tapAction:(UITapGestureRecognizer *)gesture{
    if (self.frontVCPosition == kFrontPositionRight) {
        self.frontVCPosition = kFrontPositionLeft;
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutSubView];
        }];
    }
}

-(void)panAction:(UIPanGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateChanged:
        {
            //根据手指移动的偏移量,调整view
            CGPoint point = [gesture translationInView:self.view];
            NSLog(@"%@", NSStringFromCGPoint(point));
//            _frontVC.view.frame = CGRectMake(point.x, 0, _frontVC.view.frame.size.width, _frontVC.view.frame.size.height);
            
            CGRect frame;
            //计算出手势开始时,view的起始位置
            if (self.frontVCPosition == kFrontPositionLeft) {
                frame = self.view.bounds;
            }else{
                CGFloat left = self.view.frame.size.width - self.rightWidth;
                frame = CGRectOffset(self.view.bounds, left, 0);
            }
            _frontVC.view.frame = CGRectOffset(frame, point.x, 0);
        }
            break;
        
            case UIGestureRecognizerStateEnded:
        {
            CGFloat left = self.view.frame.size.width - self.rightWidth;
            if (self.frontVC.view.frame.origin.x > left/2) {
                self.frontVCPosition = kFrontPositionRight;
            }else{
                self.frontVCPosition = kFrontPositionLeft;
            }
            __weak SiderslipVC *vc = self;
            [UIView animateWithDuration:.25f animations:^{
                [vc layoutSubView];
            }];
            
             
            
        }
            break;
        default:
            break;
    }
    
    
    
}

@end
