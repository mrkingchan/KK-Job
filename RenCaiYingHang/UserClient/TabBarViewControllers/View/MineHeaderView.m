//
//  MineHeaderView.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/22.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "MineHeaderView.h"

#import "JKBannarView.h"

@interface MineHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (strong,nonatomic) JKBannarView * bannerScrollView;


@end

@implementation MineHeaderView
{
    __weak IBOutlet UILabel *userName;
    __weak IBOutlet UILabel *userStates;
    
}

- (JKBannarView *)bannerScrollView
{
    if (!_bannerScrollView) {
        _bannerScrollView = [[JKBannarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth , self.height*0.4) viewSize:CGSizeMake(kScreenWidth, self.height * 0.4)];
        [_bgView addSubview:_bannerScrollView];
    }
    return _bannerScrollView;
}

- (void)setUser:(NSDictionary *)user
{
    _user = user;
    userName.text = user[@"name"];
    userStates.text = user[@"job_condition_id_desc"];
    [_iconBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KIMGURL,user[@"image"]]] forState:UIControlStateNormal];
}

- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    
    self.bannerScrollView.items = dataArr;
    [self.bannerScrollView imageViewClick:^(JKBannarView * _Nonnull barnerview, NSInteger index) {
        if (_mineHeaderClickCallBack) {
            _mineHeaderClickCallBack(index);
        }
        NSLog(@"点击图片%ld",index);
    }];
}

- (IBAction)buttonClick:(UIButton *)sender {
    if (_mineHeaderButtonCallBack) {
        _mineHeaderButtonCallBack(sender.tag);
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconBtn.layer.cornerRadius = self.iconBtn.height/2;
    // Initialization code
}

@end