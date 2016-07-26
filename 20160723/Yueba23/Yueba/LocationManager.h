//
//  LocationManager.h
//  Yueba
//
//  Created by qingyun on 16/7/16.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>

//定位成功的block
typedef void(^LocationUpdate)(CLLocationCoordinate2D coordinate);
//查找周围用户成功
typedef void(^NearbyUpdate)(NSArray *userInfos);

@interface LocationManager : NSObject

//回调定位的结果
@property (nonatomic, copy)LocationUpdate locationUpdate;
@property (nonatomic, copy)NearbyUpdate nearbyUpdate;

//定位到用户位置,查找到周围用户,得到用户信息
@property (nonatomic, strong)NSArray *userinfos;

+(instancetype)shareLocationManager;

-(void)startUpdateLocation;
-(void)endUPdateLocation;


@end
