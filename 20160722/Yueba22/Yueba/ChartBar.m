//
//  ChartBar.m
//  Yueba
//
//  Created by qingyun on 16/7/22.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "ChartBar.h"
#import <AVOSCloudIM.h>
#import <Masonry.h>

@interface ChartBar ()<UITextViewDelegate>


@end

@implementation ChartBar

-(void)awakeFromNib{
    //xib初始化方法
    self.inputTextView.delegate =self;
}

- (IBAction)sendMessage:(id)sender {
    //发送内容;
    AVIMTextMessage *message = [AVIMTextMessage messageWithText:self.inputTextView.text attributes:nil];
    [self.delegate sendMessage:message];
    
    self.inputTextView.text = nil;
    //更新输入栏
    [self changeSelfHeight];
}

#pragma text view delegate

-(void)textViewDidChange:(UITextView *)textView{
    //文字已经改变
    [self changeSelfHeight];
    
}

//监听用户输入
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //用户输入的回车
    if ([text isEqualToString:@"\n"]) {
        //调用发送方法
        [self sendMessage:textView];
        return NO;
    }
    return YES;
}


-(void)changeSelfHeight{
    //根据现在文字的高度,调整父视图的高度
    CGSize size = self.inputTextView.contentSize;
    
    CGFloat height = size.height + 8 + 8;
    //限制最大高度150
    height  = height > 150 ? 150 : height;
    //最低高度 50
    
    height = height < 50 ? 50 : height;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}


@end
