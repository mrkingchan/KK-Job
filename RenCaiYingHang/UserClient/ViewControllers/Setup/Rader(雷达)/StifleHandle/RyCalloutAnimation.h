//
//  RyCalloutAnimation.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface RyCalloutAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy,readonly) NSString *title;
@property (nonatomic, copy,readonly) NSString *subtitle;

#pragma mark 左侧图标
@property (nonatomic,strong) UIImage *icon;
#pragma mark 详情描述
@property (nonatomic,copy) NSString *detail;
@property (nonatomic,copy) NSString * distance;

@end
