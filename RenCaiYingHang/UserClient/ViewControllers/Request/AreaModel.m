//
//  AreaModel.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/15.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        _cityId = [dic[@"id"] intValue];
        [self mj_setKeyValues:dic];
    }
    return self;
}

@end
