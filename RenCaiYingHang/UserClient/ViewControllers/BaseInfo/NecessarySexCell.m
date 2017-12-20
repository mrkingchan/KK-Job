//
//  NecessarySexCell.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/20.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "NecessarySexCell.h"

@implementation NecessarySexCell
{
    __weak IBOutlet UIButton *manBtn;
    __weak IBOutlet UIButton *womanBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)buttonClick:(UIButton *)sender {
    
    if (sender.tag == 11) {
        manBtn.selected = true;
        womanBtn.selected = false;
    }else{
        manBtn.selected = false;
        womanBtn.selected = true;
    }
    if (_NecessarySexSelectCall) {
        _NecessarySexSelectCall(sender.tag - 10);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
