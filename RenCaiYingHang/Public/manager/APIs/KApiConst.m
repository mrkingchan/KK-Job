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
 端口
 */
NSString * const KBaseURL = @"http://192.168.2.108:8081/weixi_rcyh/";

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
 最新职位
 */
NSString * const GetNewJobList = @"index/getNewEstJobList";

/**
 搜索关键词
 **/
NSString * const SearchJobList =  @"public/app/job/searchJob";

@end
