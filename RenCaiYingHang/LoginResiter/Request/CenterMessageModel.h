//
//  CenterMessageModel.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/25.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYBaseModel.h"

@interface CenterMessageModel : RYBaseModel

@property (nonatomic,assign) int mId;//":1513846760135101,
@property (nonatomic,assign) int fromId;//":"-1",
@property (nonatomic,assign) int toId;//":"1320722",
@property (nonatomic,copy) NSString * title;//":"提现提交通知",
@property (nonatomic,copy) NSString * content;//":"【人才赢行】您的提现申请已提交，预计2017-12-22到账，请注意查收！",
@property (nonatomic,assign) int isRead;//":"0",
@property (nonatomic,assign) int TYPE;//":"1",

@end
