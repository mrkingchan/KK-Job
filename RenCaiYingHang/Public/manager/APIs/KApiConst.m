//
//  KApiConst.m
//  TalentsBlank
//
//  Created by Macx on 2017/11/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "KApiConst.h"

@implementation KApiConst

/** 验证码秒数 */
CGFloat KAuthCodeSecond = 120;

/** 参数格式为 datas */
NSString * const KDatas = @"datas";

/** 端口 */
//@"http://192.168.2.122:8084/app_rcyh/"
//@"http://192.168.2.101:8083/app_rcyh/"
//@"http://192.168.2.8:8085/app_rcyh/"

//http://app.rcyhj.com/
NSString * const KBaseURL = @"http://192.168.2.8:8085/app_rcyh/";

/** 图片拼接地址 */
NSString * const KIMGURL = @"http://pf.rcyhj.com/";

/** pageSize */
NSUInteger  const PageSize =  5;

/** DESKEY **/
NSString * const DESKEY = @"rUv20rYV";

/** 验证手机号码是否存在接口 */
NSString * const CheckPhone = @"identity/checkPhone";

/** 获取短信验证码接口 **/
NSString * const GetAuthCode =  @"identity/sendsms";

/** 注册 */
NSString * const RegisterPort = @"identity/regist";

/** 登陆认证 **/
NSString * const IsLoginOut = @"securityCenter/loginAuth";

/** 获取所有省份接口 */
NSString * const GetProvinceInfo = @"identity/getProvinceInfo";

/** 省份id获取城市接口 */
NSString * const GetCityInfo = @"identity/getCityInfoByFather";

/** 验证是否完善了基本资料 */
NSString * const WhetherBasicInfo = @"securityCenter/whetherBaseInfo";

/** 基本资料 */
NSString * const BasicInfo = @"identity/regist/basicInfo";

/** 登陆 */
NSString * const LoginPort = @"identity/login";

/** 扫码领面试奖接口 */
NSString * const ScanCodeInterviewAward = @"identity/scanCodeInterviewAward";

/** 是否实名认证和邮箱认证 */
NSString * const GetEmailAndIdcard = @"securityCenter/getEmailAndIdcard";

/** 实名认证 */
NSString * const IdcardAuthentication = @"securityCenter/idcardAuthentication";

/** 发送邮箱验证码 **/
NSString * const BindingEmail = @"securityCenter/bindingEmail";

/** 邮箱绑定接口 */
NSString * const AuthEmail = @"securityCenter/authEmail";

/** 修改登陆密码 */
NSString * const ChgPassword = @"securityCenter/updtLoginPwd";

/** 找回密码 */
NSString * const ChgLoginPwdByPhone = @"securityCenter/chgLoginPwdByPhone";

/** 手机号码修改交易密码 */
NSString * const ChgTradePwdByPhone = @"securityCenter/chgTradePwdByPhone";

/** 进入企业列表 */
NSString * const CompanyList = @"public/company/companyList";

/** 个人中心 */
NSString * const PersonCenter = @"identity/userIndex";

/** 个人中心获取简历基本信息 */
NSString * const AppUsGetBaseInfo = @"securityCenter/appUsGetBaseInfo";

/** 个人中心消息 */
NSString * const CenterMessage = @"apply/message/messageTag";

/** 支付接口 **/
NSString * const AppPay = @"appWxPay/recharge";

/** 职位搜索 **/
NSString * const NearJobSearch = @"public/job/searchRadar";

/** 上传文件 */
NSString * const UploadFiles = @"securityCenter/uploadTotal";

@end

