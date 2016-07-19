//
//  QYCreatAccuntVC.m
//  Yueba
//
//  Created by qingyun on 16/7/14.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYCreatAccuntVC.h"
#import "QYHTTPManager.h"
#import <SVProgressHUD.h>


@interface QYCreatAccuntVC ()
@property (weak, nonatomic) IBOutlet UITextField *smsFild;
@property (weak, nonatomic) IBOutlet UITextField *pwdFild;

@end

@implementation QYCreatAccuntVC

- (IBAction)createdAccount:(id)sender {
    //本地检查短信验证码
    
    //本地检查密码
    
    //向服务器提交
    [[QYHTTPManager qyManager] CreatedAccount:_phoneNumber SMSCode:_smsFild.text Pwd:_pwdFild.text CompletionHandle:^(id responseObject, NSURLSessionTask *task, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
       
        NSLog(@"%@", responseObject);
        BOOL success = [[responseObject objectForKey:@"success"] boolValue];
        if (success) {
            //跳转到提交信息页面
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"uploadinfovc"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            //登录失败;
            [SVProgressHUD showErrorWithStatus:@"注册失败"];
        }
        
    }];
    
    
}

@end
