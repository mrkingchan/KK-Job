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
    //interviewNumber.text = [NSString stringWithFormat:@"10"];
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
