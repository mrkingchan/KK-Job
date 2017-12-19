//
//  KApiConst.m
//  TalentsBlank
//
//  Created by Macx on 2017/11/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "KApiConst.h"

@implementation KApiConst

/**
 验证码秒数
 */
CGFloat KAuthCodeSecond = 120;

/**
 参数格式为 datas
 */
NSString * const KDatas = @"datas";

/**
 端口
 */
NSString * const KBaseURL = @"http://192.168.2.8:8085/app_rcyh/";

/**
 图片拼接地址
 */
NSString * const KIMGURL = @"http://pf.rcyhj.com/";

/**
 pageSize
 */
NSUInteger  const PageSize =  5;

/**
 DESKEY
 **/
NSString * const DESKEY = @"rUv20rYV";

/**
 验证手机号码是否存在接口
 */
NSString * const CheckPhone = @"identity/checkPhone";

/**
 获取短信验证码接口
 **/
NSString * const GetAuthCode =  @"identity/sendsms";

/**
 注册
 */
NSString * const RegisterPort = @"identity/regist";

/**
 获取所有省份接口
 */
NSString * const GetProvinceInfo = @"identity/getProvinceInfo";

/**
 省份id获取城市接口
 */
NSString * const GetCityInfo = @"identity/getCityInfoByFather";

/**
 基本资料
 */
NSString * const BasicInfo = @"identity/basicInfo";

/**
 登陆
 */
NSString * const LoginPort = @"identity/login";

/**
 扫码领面试奖接口
 */
NSString * const ScanCodeInterviewAward = @"identity/scanCodeInterviewAward";

/**
 实名认证
 */
NSString * const IdcardAuthentication = @"securityCenter/idcardAuthentication";

/**
 发送邮箱验证码
 **/
NSString * const BindingEmail = @"securityCenter/bindingEmail";

/**
 邮箱绑定接口
 */
NSString * const AuthEmail = @"securityCenter/authEmail";

/**
 修改登陆密码
 */
NSString * const ChgPassword = @"securityCenter/updtLoginPwd";

/**
 找回密码
 */
NSString * const ChgLoginPwdByPhone = @"securityCenter/chgLoginPwdByPhone";

/**
 手机号码修改交易密码
 */
NSString * const ChgTradePwdByPhone = @"securityCenter/chgTradePwdByPhone";

/**
 进入企业列表
 */
NSString * const CompanyList = @"public/company/companyList";

@end
