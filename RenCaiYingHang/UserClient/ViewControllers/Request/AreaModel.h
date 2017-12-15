//
//  AreaModel.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/15.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYBaseModel.h"

@interface AreaModel : RYBaseModel

@property (nonatomic,assign) NSInteger provinceID;

@property (nonatomic,copy) NSString * aliasName;

@property (nonatomic,assign) NSInteger cityId;

@property (nonatomic,copy) NSString * city;

@end
