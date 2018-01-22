//
//  UserInfoManage.m
//  TalentsBlank
//
//  Created by Macx on 2017/11/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "UserInfoManage.h"

#import "PCCircleViewConst.h"

static UserInfoManage * userManage;

@implementation UserInfoManage

/** 创建单例 **/
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManage  = [[UserInfoManage alloc]init];
        assert(userManage != nil);
    });
    return userManage;
}

/** 删除用户信息 **/
- (void)removeUserInfo
{
    userManage.userInfo = nil;
    _is_login = NO;
}

/** 退出登录 **/
- (void)loginOut
{
    userManage.userInfo = nil;
    _is_login = NO;
    
    [RYDefaults setObject:@"" forKey:[NSString stringWithFormat:UserCache]];
    [PCCircleViewConst saveGesture:nil Key:gestureFinalSaveKey];
    [[NSUserDefaults standardUserDefaults] setObject:@"close" forKey:@"setOn"];
}

@end
