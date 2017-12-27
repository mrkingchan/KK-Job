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


/** resumeId **/
@property (nonatomic,copy) NSString * resumeId;
/** 头像 */
@property (nonatomic,copy) NSString * image;
/** 附件简历地址 */
@property (nonatomic,copy) NSString * resumeImage;

@end
