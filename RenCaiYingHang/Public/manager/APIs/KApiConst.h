//
//  KApiConst.h
//  TalentsBlank
//
//  Created by Macx on 2017/11/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KApiConst : NSObject


/** 验证码秒数 */
extern CGFloat KAuthCodeSecond;

/** 参数格式为 datas */
extern NSString * const KDatas;

/** 端口 */
extern NSString * const KBaseURL;

/** 图片拼接地址 */
extern NSString * const KIMGURL;

/** pageSize */
extern NSUInteger const PageSize;

/** DESKEY **/
extern NSString * const DESKEY;

/** 验证手机号码是否存在接口 */
extern NSString * const CheckPhone;

/** 获取短信验证码接口 **/
extern NSString * const GetAuthCode;

/** 注册 */
extern NSString * const RegisterPort;

/** 登陆认证 **/
extern NSString * const IsLoginOut;

/** 获取所有省份接口 */
extern NSString * const GetProvinceInfo;

/** 省份id获取城市接口 */
extern NSString * const GetCityInfo;

/** 验证是否完善了个人基本资料 */
extern NSString * const WhetherBasicInfo;

/** 验证是否完善了企业基本资料 */
extern NSString * const AppComWhetherBaseInfo;

/** 基本资料 */
extern NSString * const BasicInfo;

/** 登陆 */
extern NSString * const LoginPort;

/** 扫码领面试奖接口 */
extern NSString * const ScanCodeInterviewAward;

/** 是否实名认证和邮箱认证 */
extern NSString * const GetEmailAndIdcard;

/** 实名认证 */
extern NSString * const IdcardAuthentication;

/** 发送邮箱验证码 **/
extern NSString * const BindingEmail;

/** 邮箱绑定接口 */
extern NSString * const AuthEmail;

/** 修改登陆密码 */
extern NSString * const ChgPassword;

/** 找回密码 */
extern NSString * const ChgLoginPwdByPhone;

/** 手机号码修改交易密码 */
extern NSString * const ChgTradePwdByPhone;

/** 进入企业列表 */
extern NSString * const CompanyList;

/** 个人中心 */
extern NSString * const PersonCenter;

/** 个人中心获取简历基本信息 */
extern NSString * const AppUsGetBaseInfo;

/** 个人中心消息 */
extern NSString * const CenterMessage;

/** 支付接口 **/
extern NSString * const AppPay;

/** 职位搜索 **/
extern NSString * const NearJobSearch;

/** 上传文件 */
extern NSString * const UploadFiles;

@end
