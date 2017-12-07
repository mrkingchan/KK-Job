//
//  RYBaseModel.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYBaseModel.h"

@implementation RYBaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        [self mj_setKeyValues:dic];
    }
    return self;
}

@end
