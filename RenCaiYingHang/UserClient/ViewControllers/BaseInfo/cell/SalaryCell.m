//
//  SalaryCell.m
//  RenCaiYingHang
//
//  Created by Macx on 2018/1/11.
//  Copyright © 2018年 Macx. All rights reserved.
//

#import "SalaryCell.h"

@implementation SalaryCell
{
    __weak IBOutlet UIButton *qwBtn;
}

- (IBAction)buttonClick:(UIButton *)sender {
    
    if (sender.tag == 10) {
        qwBtn.selected = true;
        _selectMianYi.selected = false;
        _tf.enabled = true;
        [_tf setText:@""];
    }else{
        qwBtn.selected = false;
        _selectMianYi.selected = true;
        _tf.enabled = false;
        [_tf setText:@""];
        if (_necessaryMianYiSelectCall) {
            _necessaryMianYiSelectCall(sender.selected);
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
