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
#import "Common.h"
#import <AVOSCloud.h>

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
    
//    DMLog(@"%@", application);
//    NSLog(@"%s %@", __PRETTY_FUNCTION__,[NSString stringWithFormat:@"%@", application]);
//    {};;
    
    
//    for (int i = 0; i < 1000; i ++) {
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img1.imgtn.bdimg.com/it/u=662999743,2505751590&fm=21&gp=0.jpg"]];
//    [data writeToFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.png"] atomically:YES];
//    }
    
    self.mapManager = [[BMKMapManager alloc] init];
    BOOL result = [self.mapManager start:@"KfcoyZ3TpSVZCSB2HNDK6MbljdiXxgya" generalDelegate:self];
    if (result) {
        NSLog(@"baidu 注册appkey成功");
    }
    
    
    //leanCloud平台初始化
    [AVOSCloud setApplicationId:@"0Yt1LLc3pLTnT5wXKBaeDIgt-gzGzoHsz"
                      clientKey:@"CEN8JifBKDyvGhmTfeWoruS9"];
    
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
    
    SWRevealViewController *homeVC = [homeStory instantiateViewControllerWithIdentifier:@"mainvc"];
    
    //右边视图宽度
    homeVC.rightViewRevealWidth = kScreenWidth - 60;
    //左边视图宽度
    homeVC.rearViewRevealWidth = kScreenWidth - 60;
    
    
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

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Qingyun.PersonCard" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//懒加载,初始化model文件
- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Yueba" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    
    //另外一种写法
    //    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}


//懒加载初始化 psc
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    //初始化psc
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    //PersonCard.sqlite 文件在沙盒下的路径
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PersonCard.sqlite"];
    
    NSLog(@"dbpath%@", storeURL);
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


//懒加载,初始化上下文,懒加载
- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
