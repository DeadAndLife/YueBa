//
//  RearVC.m
//  Yueba
//
//  Created by qingyun on 16/7/16.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "RearVC.h"
#import <SWRevealViewController.h>

@interface RearVC ()

@property (nonatomic)NSInteger selectedRow;//当前选择的行;

@end

@implementation RearVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.selectedRow = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    //选择不同行,切换不同控制器
//    SWRevealViewController *revalVC = self.revealViewController;
//    switch (indexPath.row) {
//        case 0:
//        {
//            //把当前控制器,复位
//            if (indexPath.row == self.selectedRow) {
//                [revalVC setFrontViewPosition:FrontViewPositionLeft animated:YES];
//            }else{
//                //切换前面的控制器
//                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
//                UIViewController *homenav= [story instantiateViewControllerWithIdentifier:@"homenav"];
//                [revalVC pushFrontViewController:homenav animated:YES];
//            }
//        }
//            break;
//        case 1:
//        {
//            if (indexPath.row == self.selectedRow) {
//                [revalVC setFrontViewPosition:FrontViewPositionLeft animated:YES];
//            }else{
//                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
//                UIViewController *settingnav = [story instantiateViewControllerWithIdentifier:@"settingnav"];
//                [revalVC pushFrontViewController:settingnav animated:YES];
//            }
//        }
//            
//        default:
//            break;
//    }
//    self.selectedRow = indexPath.row;
//    
//}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
