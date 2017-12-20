//
//  RYAlertAction.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/20.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYAlertAction : UIView

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr;

@property (nonatomic,copy) void (^ryAlertActionCall)(NSInteger index);

- (void) show;

@end
