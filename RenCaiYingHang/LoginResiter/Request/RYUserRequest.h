//
//  RYUserRequest.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/15.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CenterMessageModel.h"

#import "BannerImageModel.h"

@interface RYUserRequest : NSObject

/** 验证手机号码是否存在 */
+ (void) verdictIsExistPhoneWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isExistPhone))sucess failure:(void(^)(id errorCode))failure;

/** 获取短信验证码 **/
+ (void) gainAuthCodeWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSendSuccess))sucess failure:(void(^)(id errorCode))failure;

/** 注册 */
+ (void) userRegisterWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSendSuccess))sucess failure:(void(^)(id errorCode))failure;

/** 登陆认证 **/
+ (void) loginAuthWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSendSuccess))sucess failure:(void(^)(id errorCode))failure;

/** 是否完善基本信息 **/
+ (void) whetherBaseInfoWithParamer:(NSDictionary *)paramer suceess:(void(^)(NSString * whetherUserBaseInfo,NSDictionary * whetherComBaseInfo))sucess failure:(void(^)(id errorCode))failure;

/** 基本信息 */
+ (void) uploadBaseInfoWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSendSuccess))sucess failure:(void(^)(id errorCode))failure;

/** 登陆 */
+ (void) userLoginWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSendSuccess))sucess failure:(void(^)(id errorCode))failure;

/** 获取求职者邮箱，身份证(用以判断是否认证绑定) **/
+ (void) getEmailAndIdcardWithParamer:(NSDictionary *)paramer suceess:(void(^)(AuthenticationModel * model))sucess failure:(void(^)(id errorCode))failure;

/** 实名认证 */
+ (void) idcardAuthenticationWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure;

/** 发送邮箱验证码 */
+ (void) bindingEmailWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure;

/** 邮箱绑定接口 */
+ (void) authEmailWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure;

/** 修改登陆密码 */
+ (void) updtLoginPwdWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure;

/** 找回密码 */
+ (void) findLoginPwdWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure;

/** 修改交易密码 */
+ (void) chgTradePwdByPhoneWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure;

/** 扫码领面试奖 */
+ (void) scanCodeInterviewAwardWithWithParamer:(NSString *)paramer suceess:(void(^)(NSString * urlString))sucess failure:(void(^)(id errorCode))failure;

/** 个人中心获取简历基本信息 **/
+ (void) appUsGetBaseInfoSuceess:(void(^)(NSDictionary * baseInfo,NSArray * imageArr))sucess failure:(void(^)(id errorCode))failure;

/** 个人中心获取消息 */
+ (void) centerMessageSucess:(void(^)(NSArray * dataArr))sucess failure:(void(^)(id errorCode))failure;

/** 个人简历状态改变 */
+ (void) updateResumeInfoWithParamer:(NSDictionary *)paramer suceess:(void(^)(BOOL isSuccess))sucess failure:(void(^)(id errorCode))failure;

@end
