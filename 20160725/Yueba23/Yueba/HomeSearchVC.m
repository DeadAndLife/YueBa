//
//  HomeSearchVC.m
//  Yueba
//
//  Created by qingyun on 16/7/16.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "HomeSearchVC.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "LocationManager.h"
@interface HomeSearchVC ()
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *animationView;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@end

@implementation HomeSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak HomeSearchVC *search = self;
    //设置回调
    LocationUpdate update = ^(CLLocationCoordinate2D coordinate){
        //地图的中心点,和放大比例
        [search.mapView setCenterCoordinate:coordinate];
        search.mapView.zoomLevel = 15;
    };
    [LocationManager shareLocationManager].locationUpdate = update;
    [[LocationManager shareLocationManager] startUpdateLocation];
    
}

-(void)viewDidLayoutSubviews{
    //将地图切为圆角
    self.mapView.layer.cornerRadius = self.mapView.bounds.size.width/2;
    self.mapView.layer.masksToBounds = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //给视图加上动画
    [self animationRotating];
}


//加上旋转动画
-(void)animationRotating{
    //水平的旋转动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:-2 * M_PI];//动画移动的目标
    animation.duration = 5;//时间
    animation.repeatCount = MAXFLOAT;//循环次数
    animation.cumulative = YES;//动画结束复位;
    
    
    [_animationView.layer removeAllAnimations];
    [_animationView.layer addAnimation:animation forKey:@"transform.rotation.z"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
