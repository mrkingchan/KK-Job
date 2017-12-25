//
//  CenterMessageModel.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/25.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "CenterMessageModel.h"

@implementation CenterMessageModel


- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        _mId = [dic[@"id"] intValue];
        [self mj_setKeyValues:dic];
    }
    return self;
}

@end
