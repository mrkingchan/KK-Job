//
//  SalaryCell.h
//  RenCaiYingHang
//
//  Created by Macx on 2018/1/11.
//  Copyright © 2018年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalaryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *tf;

@property (weak, nonatomic) IBOutlet UIButton *selectMianYi;

@property (nonatomic,copy) void(^necessaryMianYiSelectCall) (BOOL isSelect);

@end
