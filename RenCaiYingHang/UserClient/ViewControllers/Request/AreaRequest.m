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
    NSDictionary * dic = [UtilityHelper encryptParmar:paramer];
    [NetWorkHelper getWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        
        NSMutableArray * arr = [NSMutableArray array];
        NSArray * rel = data[@"rel"];
        for (NSDictionary * d in rel) {
            AreaModel * model = [[AreaModel alloc] initWithDictionary:d];
            [arr addObject:model];
        }
        sucess(arr);
    } failure:^(NSError *error) {
        
    }];
}

/**
 获取省份下面的城市
 **/
+ (void) getCityInfoWithParamer:(NSDictionary *)paramer suceess:(void(^)(NSArray * dataArr))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,GetCityInfo];
    NSDictionary * dic = [UtilityHelper encryptParmar:paramer];
    [NetWorkHelper getWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        NSMutableArray * arr = [NSMutableArray array];
        NSArray * rel = data[@"rel"];
        for (NSDictionary * d in rel) {
            AreaModel * model = [[AreaModel alloc] initWithDictionary:d];
            [arr addObject:model];
        }
        sucess(arr);
    } failure:^(NSError *error) {
        
    }];
}

/** 附近职位 */
+ (void) getJobInfoWithParamer:(NSDictionary *)paramer suceess:(void(^)(NSArray * dataArr))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,NearJobSearch];
    NSString * jsonstr =   [@{@"token":UserInfo.userInfo.token,@"pkey":UserInfo.userInfo.pkey} mj_JSONString];
    NSDictionary * dic = @{KDatas:[UtilityHelper encryptUseDES2:[paramer mj_JSONString] key:DESKEY],@"token":[UtilityHelper encryptUseDES2:jsonstr key:DESKEY]};
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        NSMutableArray * arr = [NSMutableArray array];
        NSArray * rel = data[@"rel"];
        for (NSDictionary * d in rel) {
            RyJobModel * model = [[RyJobModel alloc] initWithDictionary:d];
            [arr addObject:model];
        }
        sucess(arr);
    } failure:^(NSError *error) {
        
    }];
}

@end
