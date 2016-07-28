//
//  LocationManager.m
//  Yueba
//
//  Created by qingyun on 16/7/16.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "LocationManager.h"
#import "QYAccount.h"
#import "QYHTTPManager.h"
#import "UserInfo.h"

@interface LocationManager ()<BMKLocationServiceDelegate, BMKRadarManagerDelegate>

@property (nonatomic, strong)BMKLocationService *locationService;
@property (nonatomic, strong)BMKRadarManager *radarManager;
@property (nonatomic, strong)CLLocation *cruuentLocation;//当前位置

@end

@implementation LocationManager

- (void)dealloc
{
    self.nearbyUpdate = nil;
    self.locationUpdate = nil;
    
}

+(instancetype)shareLocationManager{
    static LocationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LocationManager alloc] init];
    });
    return manager;
}

-(void)startUpdateLocation{
    [self.locationService startUserLocationService];
}

-(void)endUPdateLocation{
    [self.locationService stopUserLocationService];
}


-(BMKLocationService *)locationService{
    if (!_locationService) {
        _locationService = [[BMKLocationService alloc] init];
        _locationService.distanceFilter = 100.f;
        _locationService.desiredAccuracy = kCLLocationAccuracyBest;//精度
        _locationService.delegate = self;
    }
    return _locationService;
}

-(BMKRadarManager *)radarManager{
    if (!_radarManager) {
        //初始化delegate
        _radarManager = [BMKRadarManager getRadarManagerInstance];
        //设置查找的标识符
        _radarManager.userId = [QYAccount shareAccount].userId;
//        _radarManager.userId =@"14";
        //设置Delegate
        [_radarManager addRadarManagerDelegate:self];
    }
    return _radarManager;
}

#pragma mark - location service

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    //保存当前位置
    self.cruuentLocation = userLocation.location;
    
    //block 回调
    self.locationUpdate(userLocation.location.coordinate);
    
    //上传用户信息的对象
    BMKRadarUploadInfo *info = [[BMKRadarUploadInfo alloc] init];
    info.pt = userLocation.location.coordinate;
    
    //执行上传,返回值代表"开始上传"成功还是失败
    BOOL result = [self.radarManager uploadInfoRequest:info];
    if (result) {
        NSLog(@"上传成功");
    }else{
        NSLog(@"上传失败");
    }
    
}

-(void)didFailToLocateUserWithError:(NSError *)error{
    
}

//上传位置信息成功的Delegate
-(void)onGetRadarUploadResult:(BMKRadarErrorCode)error{
    NSLog(@"upload:%d", error);
    //检索周边条件
    BMKRadarNearbySearchOption *option = [[BMKRadarNearbySearchOption alloc] init]
    ;
    option.radius = 8000;//检索半径
    option.sortType = BMK_RADAR_SORT_TYPE_DISTANCE_FROM_NEAR_TO_FAR;//排序方式
    option.centerPt = self.cruuentLocation.coordinate;//检索中心点
    //发起检索
    BOOL res = [_radarManager getRadarNearbySearchRequest:option];
    if (res) {
        NSLog(@"发起检索成功");
    }else{
        NSLog(@"发起检索失败");
    }
}

//检索到周围用户后,请求用户信息
-(void)onGetRadarNearbySearchResult:(BMKRadarNearbyResult *)result error:(BMKRadarErrorCode)error{
    NSLog(@"near:%d", error);
    //没有错误
    if (error == 0) {
        NSLog(@"%ld", result.infoList.count);
    }
    
    
    //得到所有的useID
    //遍历每一页
    NSMutableArray *allInfos = [NSMutableArray array];
    for (int i = 0; i < result.pageNum; i ++) {
        result.pageIndex = i;
        //遍历页中的每一条记录
        NSArray *infoList = result.infoList;
        for (int j = 0; j < result.currNum; j ++) {
            BMKRadarNearbyInfo *info = infoList[j];
            [allInfos addObject:info];
        }
    }
    
    //取出数组中的每个对象的userId属性
    NSArray *allIds = [allInfos valueForKeyPath:@"userId"];
    allIds =@[@"1", @"2", @"3", @"4", @"5", @"6", @"7"];
    
    //判断在本地core data中没有保存过Uid
    
    QYHTTPManager *manager = [QYHTTPManager qyManager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //请求对应用户的用户信息
    [manager getUserInfoWithUserIds:allIds Gender:nil CompletionHandle:^(id responseObject, NSURLSessionTask *task, NSError *error) {
        if (error) {
            NSLog(@"请求错误");
            return;
        }
        NSLog(@"%@", responseObject);
        BOOL success = [responseObject[@"success"] boolValue];
        if (success) {
            NSArray *userInfos = responseObject[@"data"];
            //转化为model
            NSMutableArray *userInfoModels = [NSMutableArray array];
            for (int i = 0; i < userInfos.count; i ++) {
                NSDictionary *info = userInfos[i];
//                QYUserInfo *infoModel = [[QYUserInfo alloc] initWithDictInfo:info];
                UserInfo *user = [UserInfo createdUserInfoWithDict:info];
                
                [userInfoModels addObject:user];
            }
            
            //保留model
            self.userinfos = userInfoModels;
            
            //回调控制器
            if (self.nearbyUpdate) {
                self.nearbyUpdate(userInfoModels);
            }
            
            [self endUPdateLocation];
        }
        
    }];
    
    
}


@end
