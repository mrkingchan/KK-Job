//
//  CollectionViewCell.m
//  CollectionView
//
//  Created by Macx on 2017/12/12.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
{
    __weak IBOutlet UILabel *jobName;
    __weak IBOutlet UILabel *interviewNumber;
    __weak IBOutlet UILabel *entryNumber;
    __weak IBOutlet UILabel *salaryRange;
    __weak IBOutlet UILabel *address;
    __weak IBOutlet UILabel *years;
    __weak IBOutlet UILabel *education;

    __weak IBOutlet UIImageView *companyIcon;
    __weak IBOutlet UILabel *companyName;
    __weak IBOutlet UILabel *companyInfo;
    __weak IBOutlet UILabel *dateTime;
    
    /** 有的有 有的没有 */
    __weak IBOutlet UIView *entryCompanyView;
    __weak IBOutlet UILabel *extraAward;
}

- (void)setModel:(RyJobModel *)model
{
    _model = model;
    jobName.text = model.jobname;
    
    entryNumber.text = [NSString stringWithFormat:@"%.f",model.subsidy];
    salaryRange.text = model.salaryrange;
    address.text = [NSString stringWithFormat:@"%@-%@",model.city,model.district];
    years.text = model.job_exp_name;
    education.text = model.diploma_name;
    
    [companyIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KIMGURL,model.comlogo]] placeholderImage:nil];
    companyName.text = model.comname;
    
    NSString * msg = [NSString stringWithFormat:@"%@|%@|%@",model.finance_name,model.scale_name,model.industry_name];
    if ([VerifyHelper empty:model.finance_name]) {
        msg = [NSString stringWithFormat:@"%@|%@",model.scale_name,model.industry_name];
    }
    companyInfo.text = msg;
    
    NSString * datetime = [model.updateTime componentsSeparatedByString:@" "][1];
    NSArray * timeArr = [datetime componentsSeparatedByString:@":"];
    dateTime.text = [NSString stringWithFormat:@"%@:%@",timeArr[0],timeArr[1]];
    
    entryCompanyView.hidden = model.award == 0 ? true : false;
    extraAward.text = [NSString stringWithFormat:@"%.f",model.award];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)buttonClick:(UIButton *)sender {
    if (_collectionViewCellCallBack) {
        _collectionViewCellCallBack(sender.tag);
    }
}

@end
