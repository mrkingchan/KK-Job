//
//  AuthenticationModel.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/20.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "AuthenticationModel.h"

@implementation AuthenticationModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        _idcardNum = dic[@"idCard"];
        [self mj_setKeyValues:dic];
    }
    return self;
}

@end
