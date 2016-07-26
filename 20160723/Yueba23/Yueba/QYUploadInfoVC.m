//
//  QYUploadInfoVC.m
//  Yueba
//
//  Created by qingyun on 16/7/15.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYUploadInfoVC.h"
#import "QYHTTPManager.h"
#import "QYAccount.h"
#import <SVProgressHUD.h>


@interface QYUploadInfoVC ()
@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic) IBOutlet UITextField *nameFild;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmented;
@property (weak, nonatomic) IBOutlet UITextField *brithDayFild;
@property (strong, nonatomic) UIDatePicker *datePicker;
@end

@implementation QYUploadInfoVC

-(void)viewDidLoad{
    //初始化datepicker,用于选择生日
    self.datePicker = [[UIDatePicker alloc] init];
    //picker的类型
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    //
    NSDateComponents *Components = [[NSDateComponents alloc] init];
    //用户体验,最大用户群体为90后
    Components.year = 1990;
    //日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateFromComponents:Components];
    self.datePicker.date = date;
    
    //添加上事件
    [self.datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    //把picker作为选择生日的inputView
    self.brithDayFild.inputView = self.datePicker;
    
    
}

-(void)changeDate:(UIDatePicker *)picker{
    NSLog(@"%@", picker.date);
    //将用户选择的时间显示在输入框中
    self.brithDayFild.text = [NSDateFormatter localizedStringFromDate:picker.date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    
}

- (IBAction)upload:(id)sender {
    //验证用户输入的信息
    
    //提交用户信息
    NSString *name = self.nameFild.text;
    NSString *gender = self.genderSegmented.selectedSegmentIndex ? @"F" : @"M";
    NSDictionary *info = @{@"name":name, @"gender":gender, @"userId":[QYAccount shareAccount].uid};
    [[QYHTTPManager qyManager] uploadUserInfo:info CompletionHandle:^(id responseObject, NSURLSessionTask *task, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        
        BOOL success = [responseObject[@"success"] boolValue];
        if (success) {
            //提交信息成功
            //切换首页
        }else{
            NSString *errors = responseObject[@"errors"];
            [SVProgressHUD showErrorWithStatus:errors];
        }
        
    }];
}

@end
