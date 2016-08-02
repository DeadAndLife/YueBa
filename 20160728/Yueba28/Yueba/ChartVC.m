//
//  ChartVC.m
//  Yueba
//
//  Created by qingyun on 16/7/21.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "ChartVC.h"
#import "MessageManager.h"
#import "QYAccount.h"
#import "ChartBar.h"
#import <Masonry.h>
#import "ChartCell.h"
#import "QYAudioPlayer.h"
#import "FunctionView.h"
#import <SWRevealViewController.h>
#import "QYPhotoBrowser.h"
#import "QYPhotoBrowserTransition.h"


@interface ChartVC ()<UITableViewDataSource, UITableViewDelegate,ChartBarDelegate,MessageManagerDelegate, FunctionDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong)AVIMConversation *conversation;
@property (nonatomic, strong)ChartBar *chartBar;//聊天的输入栏

//可变数组,保存收发的消息
@property (nonatomic, strong)NSMutableArray *messagesList;

@property (nonatomic, strong)QYPhotoBrowser* browser;

@end

@implementation ChartVC

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLoad{
    
    [self creatConver];
    
    self.title = self.friendUser.name;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [MessageManager sharemessageManager].delegate = self;
    [self.chartBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kBarHeight);
    }];

    
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(_chartBar.mas_top).with.offset(0);
    }];
   
    //添加上键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}



#pragma mark - action

-(void)keyboradWillShow:(NSNotification *)notifi{
    
    //键盘的区域
    NSValue *bords = notifi.userInfo[UIKeyboardBoundsUserInfoKey];
    CGRect rect = bords.CGRectValue;
    //键盘弹出需要的时间
    NSNumber *inamation = notifi.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    
    
    //更新bar距离底部的距离
    [UIView animateWithDuration:inamation.floatValue animations:^{
        [self.chartBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-rect.size.height);
        }];
        [self.view layoutIfNeeded];
    }];
    
}

-(void)keyboardWillHide:(NSNotification *)noti{
    //动画的时间
    NSNumber *inamation = noti.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    
    //将char bar移动到最低部
    [UIView animateWithDuration:inamation.floatValue animations:^{
        [self.chartBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
        [self.view layoutIfNeeded];
    }];
}

-(void)hidesBorard:(UITapGestureRecognizer *)tap{
    //取消第一响应
    [self.chartBar.inputTextView resignFirstResponder];
    
    //找到点击的位置
    CGPoint point = [tap locationInView:self.tableView];
    
    //根据点击的位置找到对应的索引
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (!indexPath) {
        return;
    }
    
    
    AVIMTypedMessage *message = self.messagesList[indexPath.row];
    ChartCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell isTapedInContent:tap]) {
        return;
    }
    //如果点击的cell是声音cell,并且是点击在声音显示区域内,就播放声音
    if (message.mediaType == kAVIMMessageMediaTypeAudio) {
        //准备播放声音
        [message.file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            }
            NSLog(@"获取数据成功");
            //播放date
            [[QYAudioPlayer sharePlaer] playAudioWithData:data];
            
            //cell显示动画
            [cell startanimation];
        }];
    }
    //如果消息类型是图片
    if (message.mediaType == kAVIMMessageMediaTypeImage) {
        //初始化一个图片浏览器,显示选择的图片
        QYPhotoBrowser *photo = [[QYPhotoBrowser alloc] initWithNibName:nil bundle:nil];
        //要显示的图片
        photo.image = cell.showImage.image;
        
        self.seletedImageView = cell.showImage;
        photo.transitioningDelegate = self;
        self.browser = photo;
        [self.revealViewController presentViewController:photo animated:YES completion:nil];
        
    }
    
}


#pragma mark - chart

-(void)creatConver{
    AVIMClient *clint = [MessageManager sharemessageManager].clint;
    
    //会话名字
    NSString *name = [NSString stringWithFormat:@"%@ 和 %@", [QYAccount shareAccount].name, _friendUser.name];
    //会话的参与用户
    NSArray *ids = @[[QYAccount shareAccount].userId, _friendUser.userId];
    
    
    if (clint.status == AVIMClientStatusOpened) {
        [clint createConversationWithName:name clientIds:ids attributes:nil options:AVIMConversationOptionNone | AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
            //创建会话成功
            self.conversation = conversation;
            //将当前会话,标记为已读
            [self.conversation markAsReadInBackground];
            
        }];
    }else{
        [clint openWithCallback:^(BOOL succeeded, NSError *error) {
            [clint createConversationWithName:name clientIds:ids attributes:nil options:AVIMConversationOptionNone | AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
                //创建会话成功
                //创建会话成功
                self.conversation = conversation;
                //将当前会话,标记为已读
                [self.conversation markAsReadInBackground];

            }];
        }];
    }
    
}

#pragma mark - tableview delegate datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messagesList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据message收发消息,选择使用cell
    AVIMTypedMessage *message = self.messagesList[indexPath.row];
    ChartCell *cell;
    if ([message.clientId isEqualToString:[QYAccount shareAccount].userId]) {
        //自己的消息
        cell = [tableView dequeueReusableCellWithIdentifier:@"chartcellleft" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"chartcellright" forIndexPath:indexPath];
    }
    [cell bandingMessage:message];
    return cell;
    
}

#pragma mark - Chart bar delegate

-(void)sendMessage:(id)message{
    [self.conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"发送成功");
        }else{
            NSLog(@"error:%@", error);
        }
    }];
    
    //添加message到table的数据源
    [self.messagesList addObject:message];
    [self.tableView reloadData];
    
}

#pragma mark - message Delegate

//接收消息的Delegate,MessageManager调用
-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    //消息的会话,是当前会话的
    if (self.conversation == conversation) {
        NSLog(@"mess:%@", message);
        [self.messagesList addObject:message];
        [self.tableView reloadData];
    }

}

#pragma mark get/set

-(ChartBar *)chartBar{
    if (!_chartBar) {
        //从xib中加载
        _chartBar = [[[NSBundle mainBundle] loadNibNamed:@"ChartBar" owner:nil options:nil] firstObject];
        [self.view addSubview:_chartBar];
        _chartBar.backgroundColor = [UIColor grayColor];
        _chartBar.delegate = self;
    }
    return _chartBar;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        //添加手势,取消输入第一响应
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidesBorard:)];
        [_tableView addGestureRecognizer:tap];
        
        //注册cell
        UINib *left = [UINib nibWithNibName:@"ChartCellLeft" bundle:nil];
        [self.tableView registerNib:left forCellReuseIdentifier:@"chartcellleft"];
        UINib *right = [UINib nibWithNibName:@"ChartCellRight" bundle:nil];
        [self.tableView registerNib:right forCellReuseIdentifier:@"chartcellright"];
        //cell自动适配高度
        self.tableView.estimatedRowHeight = 60;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        
    }
    return _tableView;
}

-(NSMutableArray *)messagesList{
    if (!_messagesList) {
        _messagesList = [NSMutableArray array];
    }
    return _messagesList;
}

#pragma mark - function delegate

-(void)selectAction:(NSInteger)actionIndex{
    //选择图片
    switch (actionIndex) {
        case 1:
        {
            //选择图片
            [self selectImage];
        }
            break;
            
        default:
            break;
    }
    
    
}

-(void)selectImage{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.delegate = self;
    
    [self.revealViewController presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark - image picker

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //取出选择的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.revealViewController dismissViewControllerAnimated:YES completion:nil];
    
    //构造message对象
    AVFile *file = [AVFile fileWithData:UIImagePNGRepresentation(image)];
    
    AVIMImageMessage *message = [AVIMImageMessage messageWithText:[NSString stringWithFormat:@"%f:%f", image.size.width, image.size.height] file:file attributes:nil];
    
    [self sendMessage:message];
    
}

#pragma mark - UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    QYPhotoBrowserTransition *tran = [[QYPhotoBrowserTransition alloc] init];
    tran.isShow = YES;
    return tran;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    QYPhotoBrowserTransition *tran = [[QYPhotoBrowserTransition alloc] init];
    return tran;
}


@end
