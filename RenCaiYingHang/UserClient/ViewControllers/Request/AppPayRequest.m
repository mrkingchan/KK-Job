//
//  AppPayRequest.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/26.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "AppPayRequest.h"

@implementation AppPayRequest

//第三方支付
- (void) thirdPayWithParamer:(NSDictionary *)paramer suceess:(void(^)(NSDictionary * dic))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,AppPay];
    NSDictionary * dic = [UtilityHelper encryptParmar:paramer];
    [NetWorkHelper getWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        
        
        
    } failure:^(NSError *error) {
        
    }];
}

@end
