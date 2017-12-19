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
    NSString * jsonStr = [paramer mj_JSONString];
    NSString * encode = [UtilityHelper encryptParmar:jsonStr];
    NSDictionary * dic = @{KDatas:encode};
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        
    } failure:^(NSError *error) {
        
    }];
}

/** 获取短信验证码 **/
+ (void) gainAuthCodeWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSendSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,GetAuthCode];
    NSString * jsonStr = [paramer mj_JSONString];
    NSString * encode = [UtilityHelper encryptParmar:jsonStr];
    NSDictionary * dic = @{KDatas:encode};
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        sucess(true);
    } failure:^(NSError *error) {
        
    }];
}

/** 注册 */
+ (void) userRegisterWithParamer:(NSDictionary *)paramer suceess:(void(^)(NSDictionary * userInfo))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,RegisterPort];
    NSString * jsonStr = [paramer mj_JSONString];
    NSString * encode = [UtilityHelper encryptParmar:jsonStr];
    NSDictionary * dic = @{KDatas:encode};
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        //UserModel
    } failure:^(NSError *error) {
        
    }];
}

/** 基本信息 */
+ (void) uploadBaseInfoWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSendSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,BasicInfo];
    NSString * jsonStr = [paramer mj_JSONString];
    NSString * encode = [UtilityHelper encryptParmar:jsonStr];
    NSDictionary * dic = @{KDatas:encode,@"token":@""};
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        
    } failure:^(NSError *error) {
        
    }];
}

/** 登陆 */
+ (void) userLoginWithParamer:(NSDictionary *)paramer suceess:(void(^)(NSDictionary * userInfo))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,LoginPort];
    NSString * jsonStr = [paramer mj_JSONString];
    NSString * encode = [UtilityHelper encryptParmar:jsonStr];
    NSDictionary * dic = @{KDatas:encode};
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        //UserModel
    } failure:^(NSError *error) {
        
    }];
}

/** 实名认证 */
+ (void) idcardAuthenticationWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,IdcardAuthentication];
    NSString * jsonStr = [paramer mj_JSONString];
    NSString * encode = [UtilityHelper encryptParmar:jsonStr];
    NSDictionary * dic = @{KDatas:encode};
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        
    } failure:^(NSError *error) {
        
    }];
}

/** 发送邮箱验证码 */
+ (void) bindingEmailWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,BindingEmail];
    NSString * jsonStr = [paramer mj_JSONString];
    NSString * encode = [UtilityHelper encryptParmar:jsonStr];
    NSDictionary * dic = @{KDatas:encode};
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        
    } failure:^(NSError *error) {
        
    }];
}

/** 邮箱绑定接口 */
+ (void) authEmailWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,AuthEmail];
    NSString * jsonStr = [paramer mj_JSONString];
    NSString * encode = [UtilityHelper encryptParmar:jsonStr];
    NSDictionary * dic = @{KDatas:encode};
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        
    } failure:^(NSError *error) {
        
    }];
}

/** 修改登陆密码 */
+ (void) updtLoginPwdWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,ChgPassword];
    NSString * jsonStr = [paramer mj_JSONString];
    NSString * encode = [UtilityHelper encryptParmar:jsonStr];
    NSDictionary * dic = @{KDatas:encode};
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        
    } failure:^(NSError *error) {
        
    }];
}

/** 找回密码 */
+ (void) findLoginPwdWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,ChgLoginPwdByPhone];
    NSString * jsonStr = [paramer mj_JSONString];
    NSString * encode = [UtilityHelper encryptParmar:jsonStr];
    NSDictionary * dic = @{KDatas:encode};
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        
    } failure:^(NSError *error) {
        
    }];
}

/** 修改交易密码 */
+ (void) chgTradePwdByPhoneWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",KBaseURL,ChgTradePwdByPhone];
    NSString * jsonStr = [paramer mj_JSONString];
    NSString * encode = [UtilityHelper encryptParmar:jsonStr];
    NSDictionary * dic = @{KDatas:encode};
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        
    } failure:^(NSError *error) {
        
    }];
}

@end
