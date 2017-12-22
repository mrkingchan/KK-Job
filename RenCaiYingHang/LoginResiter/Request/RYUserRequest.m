//
//  RYUserRequest.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/15.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYUserRequest.h"

@implementation RYUserRequest

/** 验证手机号码是否存在 */
+ (void) verdictIsExistPhoneWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isExistPhone))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,CheckPhone];
    NSDictionary * dic = [UtilityHelper encryptParmar:paramer];
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        
    } failure:^(NSError *error) {
        
    }];
}

/** 获取短信验证码 **/
+ (void) gainAuthCodeWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSendSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,GetAuthCode];
    NSDictionary * dic = [UtilityHelper encryptParmar:paramer];
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        sucess(true);
    } failure:^(NSError *error) {
        
    }];
}

/** 注册 */
+ (void) userRegisterWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSendSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,RegisterPort];
    NSDictionary * dic = [UtilityHelper encryptParmar:paramer];
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        
        [UtilityHelper saveUserInfoWith:data];
        sucess(true);
        
    } failure:^(NSError *error) {
        
    }];
}

/** 是否完善基本信息 **/
+ (void) whetherBaseInfoWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSendSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,WhetherBasicInfo];
    [NetWorkHelper postWithURLString:urlString parameters:paramer success:^(NSDictionary *data) {
        if ([data[@"reCode"] isEqualToString:@"X0000"]) {
           sucess(true);
        }else{
           sucess(false);
        }
    } failure:^(NSError *error) {
        
    }];
}

/** 基本信息 */
+ (void) uploadBaseInfoWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSendSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,BasicInfo];
    NSDictionary * dic = [UtilityHelper encryptPkeyParmar:paramer];
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        sucess(true);
    } failure:^(NSError *error) {
        
    }];
}

/** 登陆 */
+ (void) userLoginWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSendSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,LoginPort];
    NSDictionary * dic = [UtilityHelper encryptParmar:paramer];
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        
        [UtilityHelper saveUserInfoWith:data];
        sucess(true);
        
    } failure:^(NSError *error) {
        
    }];
}

/** 获取求职者邮箱，身份证(用以判断是否认证绑定) **/
+ (void) getEmailAndIdcardWithParamer:(NSDictionary *)paramer suceess:(void(^)(AuthenticationModel * model))sucess failure:(void(^)(id errorCode))failure
{
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,GetEmailAndIdcard];
    [NetWorkHelper postWithURLString:urlString parameters:paramer success:^(NSDictionary *data) {
        
        if ([data[@"reCode"] isEqualToString:@"X0000"] && ![VerifyHelper isNull:data key:@"rel"]) {
            NSDictionary * rel =  data[@"rel"];
            AuthenticationModel * model = [[AuthenticationModel alloc] initWithDictionary:rel];
            sucess(model);
        }
        
    } failure:^(NSError *error) {
        
    }];
}

/** 实名认证 */
+ (void) idcardAuthenticationWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,IdcardAuthentication];
    NSDictionary * dic = [UtilityHelper encryptPkeyParmar:paramer];
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        sucess(true);
    } failure:^(NSError *error) {
        
    }];
}

/** 发送邮箱验证码 */
+ (void) bindingEmailWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,BindingEmail];
    NSDictionary * dic = [UtilityHelper encryptPkeyParmar:paramer];
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        sucess(true);
    } failure:^(NSError *error) {
        
    }];
}

/** 邮箱绑定接口 */
+ (void) authEmailWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,AuthEmail];
    NSDictionary * dic = [UtilityHelper encryptPkeyParmar:paramer];
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        sucess(true);
    } failure:^(NSError *error) {
        
    }];
}

/** 修改登陆密码 */
+ (void) updtLoginPwdWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,ChgPassword];
    NSDictionary * dic = [UtilityHelper encryptPkeyParmar:paramer];
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        sucess(true);
    } failure:^(NSError *error) {
        
    }];
}

/** 找回密码 */
+ (void) findLoginPwdWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,ChgLoginPwdByPhone];
    NSDictionary * dic = [UtilityHelper encryptParmar:paramer];
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        sucess(true);
    } failure:^(NSError *error) {
        
    }];
}

/** 修改交易密码 */
+ (void) chgTradePwdByPhoneWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,ChgTradePwdByPhone];
    NSDictionary * dic = [UtilityHelper encryptPkeyParmar:paramer];
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        sucess(true);
    } failure:^(NSError *error) {
        
    }];
}

/** 扫码领面试奖 */
+ (void) scanCodeInterviewAwardWithWithParamer:(NSString *)paramer suceess:(void(^)(NSString * urlString))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,ScanCodeInterviewAward];
    NSDictionary * dic = @{KDatas:paramer,@"token":UserInfo.userInfo.token};
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        //返回的应该是跳转链接
    } failure:^(NSError *error) {
        
    }];
}

@end
