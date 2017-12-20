//
//  UserInfoManage.h
//  TalentsBlank
//
//  Created by Macx on 2017/11/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserModel.h"

#define UserInfo [UserInfoManage shareInstance]

@interface UserInfoManage : NSObject

/** 用户信息 **/
@property (nonatomic,strong) UserModel * userInfo;

/**
 登录设置为YES
 退出设置为NO
 appdeltegate进入判断缓存是否存在再设置是NO还是YES
 **/
@property (nonatomic,assign) BOOL is_login;

/** 创建单例 **/
+ (instancetype) shareInstance;

/** 删除用户信息 **/
- (void)removeUserInfo;

/** 退出登录 **/
- (void)loginOut;

@end
