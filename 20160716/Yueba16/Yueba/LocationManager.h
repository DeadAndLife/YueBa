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

typedef void(^LocationUpdate)(CLLocationCoordinate2D coordinate);

@interface LocationManager : NSObject

//回调定位的结果
@property (nonatomic, copy)LocationUpdate locationUpdate;
@property (nonatomic, strong)BMKRadarManager *radarManager;

+(instancetype)shareLocationManager;

-(void)startUpdateLocation;
-(void)endUPdateLocation;


@end
