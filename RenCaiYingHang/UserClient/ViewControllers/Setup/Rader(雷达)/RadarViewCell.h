//
//  RadarViewCell.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/12.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadarViewCell : UITableViewCell

@property (nonatomic,copy) void(^radarViewCellButtonClickCall)(NSInteger index);

@end
