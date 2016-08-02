//
//  FriendList.m
//  Yueba
//
//  Created by qingyun on 16/7/16.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "FriendListVC.h"
#import "QYHTTPManager.h"
#import "QYAccount.h"
#import "UserInfo.h"
#import "FriendCell.h"
#import <SWRevealViewController.h>

@interface FriendListVC ()

@property (nonatomic, strong)NSArray *friendsList;

@end

@implementation FriendListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //读取本地数据
    self.friendsList = [UserInfo friendList];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //刷新好友列表
    [[QYHTTPManager qyManager] friendList:[QYAccount shareAccount].userId
                         CompletionHandle:^(id responseObject, NSURLSessionTask *task, NSError *error) {
       //结果
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        
        BOOL success = [responseObject[@"success"] boolValue];
        if (success) {
            //好友列表
            //保存展示
            //更新本地好友用户信息
            self.friendsList = [UserInfo updateFriendListWithDictList:responseObject[@"data"]];
            
            [self.tableView reloadData];
            
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friendsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendcell" forIndexPath:indexPath];
    UserInfo *user =self.friendsList[indexPath.row];
    cell.friendName.text = user.name;
    // Configure the 
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //好友列表全屏
    
    SWRevealViewController *revealVC  = self.revealViewController;
    //front控制器隐藏
    [revealVC setFrontViewPosition:FrontViewPositionLeftSideMost animated:YES];
    //阴影
    revealVC.frontViewShadowOffset = CGSizeZero;
    revealVC.frontViewShadowRadius = 0;
    
    UserInfo *user = self.friendsList[indexPath.row];
    
    
    UIViewController *chartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"chartvc"];
    [chartVC setValue:user forKey:@"friendUser"];
    [self.navigationController pushViewController:chartVC animated:YES];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
