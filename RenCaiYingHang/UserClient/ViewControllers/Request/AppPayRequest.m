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
+ (void) thirdPayWithParamer:(NSDictionary *)paramer suceess:(void(^)(id resopnse))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,AppPay];
    NSDictionary * dic = [UtilityHelper encryptParmar:paramer];
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        if (![VerifyHelper isNull:data key:@"rel"]) {
            sucess(data[@"rel"]);
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void) weixinPayWithParamer:(NSDictionary *)paramer
{
    PayReq * req             = [[PayReq alloc] init];
    req.partnerId           = paramer[@"partnerid"];
    req.prepayId            = paramer[@"prepayid"];
    req.nonceStr            = paramer[@"noncestr"];
    req.timeStamp           = [paramer[@"timestamp"] intValue];
    req.package             = paramer[@"package"];
    req.sign                = paramer[@"sign"];
    [WXApi sendReq:req];
}

+ (void) aliPayWithParamer:(NSString *)paramer callback:(void(^)(NSDictionary * dic))callback
{
    NSString * appScheme = @"2017122201077259";
    [[AlipaySDK defaultService] payOrder:paramer fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        if (callback) {
            callback(resultDic);
        }
        NSLog(@"reslut = %@",resultDic);
    }];
}

@end
