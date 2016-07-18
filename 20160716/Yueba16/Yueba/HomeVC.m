//
//  HomeVC.m
//  Yueba
//
//  Created by qingyun on 16/7/16.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "HomeVC.h"
#import <SWRevealViewController.h>

@interface HomeVC ()

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
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //初始化搜索界面,用模态弹出
    UIViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"homesearchvc"];
    [self presentViewController:searchVC animated:YES completion:nil];
    
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
