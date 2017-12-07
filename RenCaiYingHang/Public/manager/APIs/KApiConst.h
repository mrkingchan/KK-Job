//
//  KApiConst.h
//  TalentsBlank
//
//  Created by Macx on 2017/11/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KApiConst : NSObject


/**
 验证码秒数
 */
extern CGFloat KAuthCodeSecond;

/**
 端口
 */
extern NSString * const KBaseURL;

/**
 图片拼接地址
 */
extern NSString * const KIMGURL;

/**
 pageSize
 */
extern NSUInteger const PageSize;

/**
 DESKEY
 **/
extern NSString * const DESKEY;

/**
 最新职位
 */
extern NSString * const GetNewJobList;

/**
 搜索关键词
 **/
extern NSString * const SearchJobList;

@end
