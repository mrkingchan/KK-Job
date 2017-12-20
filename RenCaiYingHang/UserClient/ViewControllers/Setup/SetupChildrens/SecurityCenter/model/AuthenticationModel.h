//
//  AuthenticationModel.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/20.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYBaseModel.h"

@interface AuthenticationModel : RYBaseModel


@property (nonatomic,copy) NSString * realName;
@property (nonatomic,copy) NSString * idcardNum;

@property (nonatomic,copy) NSString * email;
@property (nonatomic,copy) NSString * codeString;

@property (nonatomic,copy) NSString * phone;
@property (nonatomic,copy) NSString * newsPassWord;
@property (nonatomic,copy) NSString * confirmPassWord;

@end
