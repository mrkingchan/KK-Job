//
//  RyJobModel.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYBaseModel.h"

@interface RyJobModel : RYBaseModel

//主标题
@property(nonatomic,copy)NSString *title;
//纬度
@property(nonatomic,assign)float latitudef;
//经度
@property(nonatomic,assign)float longitudef;
//大头针左侧的详情图片名称
@property(nonatomic,copy)NSString *picName;
//大头针详情左侧图标
@property(nonatomic,copy)NSString *iconName;
//详情信息
@property(nonatomic,copy)NSString *detailStr;
//距离信息
@property(nonatomic,copy)NSString *distance;
//所处数组下标
@property (nonatomic,assign) NSInteger index;

@end
