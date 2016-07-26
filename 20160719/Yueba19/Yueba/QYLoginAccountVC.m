//
//  QYLoginAccountVC.m
//  Yueba
//
//  Created by qingyun on 16/7/14.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYLoginAccountVC.h"
#import "QYHTTPManager.h"
#import <SVProgressHUD.h>
#import "QYAccount.h"
#import "AppDelegate.h"

@interface QYLoginAccountVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneFild;
@property (weak, nonatomic) IBOutlet UITextField *pwdFild;

@end

@implementation QYLoginAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    
}

- (IBAction)login:(id)sender {
    //检查手机号和密码
    
    //登录服务器
    [[QYHTTPManager qyManager] loginAccount:_phoneFild.text Pwd:_pwdFild.text CompletionHandle:^(id responseObject, NSURLSessionTask *task, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        NSLog(@"%@", responseObject);
        BOOL success = [responseObject[@"success"] boolValue];
        
        if (success) {
            //登录成功;
//            保存登陆信息
            [[QYAccount shareAccount] saveLogin:responseObject[@"data"]];
            //判断是跳转到首页,跳转到提交信息页面
            //如果没有name字段,代表没有提交过信息,跳转到提交信息页面
            NSString *name = responseObject[@"data"][@"name"];
            if (name) {
                //跳转到首页
                AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                [delegate changeRootHomeVC];
            }else{
                //跳转到提交信息页面
                UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"uploadinfovc"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            //登录失败;
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
        }
        
    }];
    
    
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
