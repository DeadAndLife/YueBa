//
//  LocationManager.m
//  Yueba
//
//  Created by qingyun on 16/7/16.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "LocationManager.h"
#import "QYAccount.h"

@interface LocationManager ()<BMKLocationServiceDelegate, BMKRadarManagerDelegate>

@property (nonatomic, strong)BMKLocationService *locationService;
@property (nonatomic, strong)CLLocation *cruuentLocation;//当前位置

@end

@implementation LocationManager

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
        //设置Delegate
        [_radarManager addRadarManagerDelegate:self];
    }
    return _radarManager;
}

#pragma mark - location service

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    self.cruuentLocation = userLocation.location;
    
    self.locationUpdate(userLocation.location.coordinate);
    
    BMKRadarUploadInfo *info = [[BMKRadarUploadInfo alloc] init];
    info.pt = userLocation.location.coordinate;
    
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
    //检索周边
    BMKRadarNearbySearchOption *option = [[BMKRadarNearbySearchOption alloc] init]
    ;
    option.radius = 8000;//检索半径
    option.sortType = BMK_RADAR_SORT_TYPE_DISTANCE_FROM_NEAR_TO_FAR;//排序方式
    option.centerPt = self.cruuentLocation.coordinate;//检索中心点
    //发起检索
    BOOL res = [_radarManager getRadarNearbySearchRequest:option];
}

-(void)onGetRadarNearbySearchResult:(BMKRadarNearbyResult *)result error:(BMKRadarErrorCode)error{
    NSLog(@"near:%d", error);
    //没有错误
    if (error == 0) {
        NSLog(@"%ld", result.infoList.count);
    }
}


@end
