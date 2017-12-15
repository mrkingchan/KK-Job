//
//  AreaRequest.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/15.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "AreaRequest.h"

@implementation AreaRequest

/**
 获取所有省份
 **/
+ (void) getProvinceInfoWithParamer:(NSDictionary *)paramer suceess:(void(^)(NSArray * dataArr))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,GetProvinceInfo];
    NSString * jsonStr = [paramer mj_JSONString];
    NSString * encode = [UtilityHelper encryptParmar:jsonStr];
    NSDictionary * dic = @{KDatas:encode};
    [NetWorkHelper getWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 获取省份下面的城市
 **/
+ (void) getCityInfoWithParamer:(NSDictionary *)paramer suceess:(void(^)(NSArray * dataArr))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,GetCityInfo];
    NSString * jsonStr = [paramer mj_JSONString];
    NSString * encode = [UtilityHelper encryptParmar:jsonStr];
    NSDictionary * dic = @{KDatas:encode};
    [NetWorkHelper getWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        
    } failure:^(NSError *error) {
        
    }];
}

@end
