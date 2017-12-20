//
//  ReviseNecessaryViewController.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/8.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYViewController.h"

@interface ReviseNecessaryViewController : RYViewController

/** 限制字数 **/
@property (nonatomic,assign) NSInteger maxLength;

@property (nonatomic,copy) void(^reviseNecessaryCall)(NSString * string);

@end
