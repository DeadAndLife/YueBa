 //
//  QYPhoneNumberVC.m
//  Yueba
//
//  Created by qingyun on 16/7/14.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYPhoneNumberVC.h"
#import "QYHTTPManager.h"

@interface QYPhoneNumberVC ()
@property (weak, nonatomic) IBOutlet UITextField *phone;


@end

@implementation QYPhoneNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendPhone:(id)sender {
    
    //用正则表达式,验证手机号
    
    //向服务器发送
//    NSDictionary *params = @{@"telephone":self.phone.text};
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager POST:@"http://yueba.applinzi.com/users/msmCaptcha.json" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    QYHTTPManager *qyManage = [QYHTTPManager qyManager];
//    [qyManage POST:@"users/msmCaptcha.json"
//        parameters:params
//  CompletionHandle:^(id responseObject, NSURLSessionTask *task, NSError *error) {
//        if (error) {
//            NSLog(@"%@", error);
//            return;
//        }
//        
//        //请求成功
//        NSLog(@"%@", responseObject);
//    }];
    
    [qyManage sendSMSCode:self.phone.text
         CompletionHandle:^(id responseObject, NSURLSessionTask *task, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        //请求成功;
        NSLog(@"%@", responseObject);
             BOOL success = [responseObject[@"success"] boolValue];
             if (success) {
                 //初始化注册账号控制器,将电话号码传递
                 UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"createdaccountvc"];
                 [vc setValue:self.phone.text forKey:@"phoneNumber"];
                 [self.navigationController pushViewController:vc animated:YES];
             }else{
                 NSLog(@"%@", responseObject[@"data"]);
             }
             
             
    }];
    
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
