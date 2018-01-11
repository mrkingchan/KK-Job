//
//  RYBaseInfoModel.h
//  RenCaiYingHang
//
//  Created by Macx on 2018/1/11.
//  Copyright © 2018年 Macx. All rights reserved.
//

#import "UserModel.h"

@interface RYBaseInfoModel : UserModel

@property (nonatomic,copy) NSString * user;

@property (nonatomic,assign) NSInteger sex;

@property (nonatomic,assign) NSInteger education;

@property (nonatomic,assign) NSInteger experience;

@property (nonatomic,copy) NSString * birthday;

@property (nonatomic,copy) NSString * job;

@property (nonatomic,copy) NSString * salary;

@property (nonatomic,copy) NSString * city;

@end
