//
//  AppDelegate.m
//  Yueba
//
//  Created by qingyun on 16/7/14.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "AppDelegate.h"
#import "QYAccount.h"
#import <SWRevealViewController.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate ()<BMKGeneralDelegate>

@property (nonatomic, strong)BMKMapManager *mapManager;

@end

@implementation AppDelegate

#pragma mark - BMKGeneralDelegate

//联网状态
-(void)onGetNetworkState:(int)iError{
    NSLog(@"联网:%d",iError);
}

//授权状态
-(void)onGetPermissionState:(int)iError{
    NSLog(@"授权:%d", iError);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.mapManager = [[BMKMapManager alloc] init];
    BOOL result = [self.mapManager start:@"KfcoyZ3TpSVZCSB2HNDK6MbljdiXxgya" generalDelegate:self];
    if (result) {
        NSLog(@"baidu 注册appkey成功");
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [self rootVC];
    [self.window makeKeyAndVisible];
    
    return YES;
}

//根据登录情况选择初始化响应的控制器,作为根控制器
-(UIViewController *)rootVC{
    if ([[QYAccount shareAccount] isLogin]) {
        if ([QYAccount shareAccount].name) {
//            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
//            UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"homevc"];
//            return vc;
            return [self createdHomeVC];
        }else{
            //如果没有用户信息
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [main instantiateViewControllerWithIdentifier:@"uploadinfovc"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            return nav;
        }
    }else{
        //登录或注册
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [main instantiateViewControllerWithIdentifier:@"loginnav"];
        return vc;
    }
}

-(void)changeRootHomeVC{
    //切换控制器到首页
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
//    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"homevc"];
    UIViewController *vc = [self createdHomeVC];
    self.window.rootViewController = vc;
}

-(UIViewController *)createdHomeVC{
    //通过代码初始化homeVC
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
//    
//    //rear
//    UIViewController *rearVC = [story instantiateViewControllerWithIdentifier:@"rear"];
//    //home
//    UIViewController *home = [story instantiateViewControllerWithIdentifier:@"home"];
//    
//    //friendlist
//    UIViewController *friend = [story instantiateViewControllerWithIdentifier:@"friendlist"];
//    
//    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:home];
//    
//    //容器控制器
//    SWRevealViewController *revealVC = [[SWRevealViewController alloc] initWithRearViewController:rearVC frontViewController:homeNav];
//    return revealVC;
    
//    通过UIStoryboard实现
    UIStoryboard *homeStory = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    
    UIViewController *homeVC = [homeStory instantiateViewControllerWithIdentifier:@"mainvc"];
    return homeVC;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
