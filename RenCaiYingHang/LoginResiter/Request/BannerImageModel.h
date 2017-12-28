//
//  BannerImageModel.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/28.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYBaseModel.h"

@interface BannerImageModel : RYBaseModel

@property (nonatomic,copy) NSString * fromCom;

@property (nonatomic,copy) NSString * urlString;

//为以后有跳转做防备
//@property (nonatomic,copy) NSString * pushUrl;
//"fromCom":"人才赢行","picUrl":"show/1507790882208742.jpg"

@end
