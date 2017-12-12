//
//  RadarViewCell.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/12.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RadarViewCell.h"

@implementation RadarViewCell
{
    __weak IBOutlet UILabel *jobName;
    __weak IBOutlet UILabel *dateTime;
    __weak IBOutlet UILabel *interviewAward;
    __weak IBOutlet UILabel *entryAward;
    __weak IBOutlet UILabel *salaryRange;
    __weak IBOutlet UILabel *address;
    __weak IBOutlet UILabel *ageLimit;
    __weak IBOutlet UILabel *education;
    __weak IBOutlet UIImageView *companyIcon;
    __weak IBOutlet UILabel *companyName;
    __weak IBOutlet UILabel *companyInfo;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)buttonClick:(UIButton *)sender {
    //11职位 12公司
    if (_radarViewCellButtonClickCall) {
        _radarViewCellButtonClickCall(sender.tag);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
