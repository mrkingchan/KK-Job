//
//  BannerImageModel.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/28.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "BannerImageModel.h"

@implementation BannerImageModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        _urlString = [NSString stringWithFormat:@"%@%@",KIMGURL,dic[@"picUrl"]] ;
        [self mj_setKeyValues:dic];
    }
    return self;
}

@end
