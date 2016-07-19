//
//  HomeVC.m
//  Yueba
//
//  Created by qingyun on 16/7/16.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "HomeVC.h"
#import <SWRevealViewController.h>
#import "LocationManager.h"
#import "QYUserInfo.h"
#import "ProfileInfoView.h"

@interface HomeVC ()

@property (nonatomic, strong)NSArray *userInfos;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //侧滑控制器
    SWRevealViewController *revalVC = self.revealViewController;
    //添加手势
    [revalVC tapGestureRecognizer];
    [revalVC panGestureRecognizer];
    
    //添加按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"Rear" style:UIBarButtonItemStylePlain target:revalVC action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = left;
    
    __weak HomeVC *home = self;
    //添加查找周围用户的block
    [LocationManager shareLocationManager].nearbyUpdate = ^(NSArray *userInfos){
        home.userInfos = userInfos;
        //刷新页面
        [self loadData];
    };
    
}

//刷新页面
-(void)loadData{
    //取消搜索界面
    [self dismissViewControllerAnimated:YES completion:nil];
    //添加用户信息界面
    for (QYUserInfo *info in self.userInfos) {
        ProfileInfoView *infoView = [[[NSBundle mainBundle] loadNibNamed:@"ProfileInfoView" owner:nil options:nil] objectAtIndex:0];
        infoView.icon.image = [UIImage imageNamed:@"icon1"];
        infoView.name.text = info.name;
        infoView.age.text  = @"18";
        [self.view addSubview:infoView];
        
        CGFloat width = self.view.frame.size.width;
        
        infoView.frame = CGRectMake(40, 20, width - 40 *2, self.view.frame.size.height - 100);
        
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //初始化搜索界面,用模态弹出
    if (!self.userInfos) {
        UIViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"homesearchvc"];
        [self presentViewController:searchVC animated:YES completion:nil];
    }
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
