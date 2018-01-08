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
@property (nonatomic,assign) NSInteger isComUser;
/** reCode 个人还是企业(微信端客户) **/
@property (nonatomic,copy) NSString * reCode;
/** comId **/
@property (nonatomic,copy) NSString * com_id;



/** 名字 */
@property (nonatomic,copy) NSString * name;
/** resumeId **/
@property (nonatomic,copy) NSString * resumeId;
/** 头像 */
@property (nonatomic,copy) NSString * image;
/** 附件简历地址 */
@property (nonatomic,copy) NSString * resumeImage;

/** 是否个人基本信息 **/
@property (nonatomic,assign) BOOL isFinishBaseInfo;
/** 是否企业基本信息 **/
@property (nonatomic,assign) BOOL isFinishComInfo;

@end
