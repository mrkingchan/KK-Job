//
//  AppPayRequest.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/26.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AppPayType) {
    WeixinPay = 1,
    AliPay,
    HuiChaoPay,
} ;

@interface AppPayRequest : NSObject

//第三方支付
+ (void) thirdPayWithParamer:(NSDictionary *)paramer suceess:(void(^)(NSDictionary * dic))sucess failure:(void(^)(id errorCode))failure;

//微信支付
+ (void) weixinPayWithParamer:(NSDictionary *)paramer;

//支付宝支付
+ (void) aliPayWithParamer:(NSString *)paramer callback:(void(^)(NSDictionary * dic))callback;

@end
