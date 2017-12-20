//
//  UserModel.h
//  TalentsBlank
//
//  Created by Macx on 2017/11/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYBaseModel.h"

@interface UserModel : RYBaseModel

/** token */
@property (nonatomic,copy) NSString * token;
/** 私钥 **/
@property (nonatomic,copy) NSString * pkey;
/** 手机号 **/
@property (nonatomic,copy) NSString * tel;
/** id区分个人还是企业 **/

@end
