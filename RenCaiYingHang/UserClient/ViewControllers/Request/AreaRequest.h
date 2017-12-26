//
//  AreaRequest.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/15.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AreaModel.h"

#import "RyJobModel.h"

@interface AreaRequest : NSObject

/**
 获取所有省份
 **/
+ (void) getProvinceInfoWithParamer:(NSDictionary *)paramer suceess:(void(^)(NSArray * dataArr))sucess failure:(void(^)(id errorCode))failure;

/**
 获取省份下面的城市
 **/
+ (void) getCityInfoWithParamer:(NSDictionary *)paramer suceess:(void(^)(NSArray * dataArr))sucess failure:(void(^)(id errorCode))failure;

/** 附近职位 */
+ (void) getJobInfoWithParamer:(NSDictionary *)paramer suceess:(void(^)(NSArray * dataArr))sucess failure:(void(^)(id errorCode))failure;

@end
