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
    __weak IBOutlet UIButton *userStates;
    __weak IBOutlet UILabel *resumeProgress;
}

- (JKBannarView *)bannerScrollView
{
    if (!_bannerScrollView) {
        _bannerScrollView = [[JKBannarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth , self.height*0.4) viewSize:CGSizeMake(kScreenWidth, self.height * 0.4)];
        _bannerScrollView.backgroundColor = kNavBarTintColor;
        [_bgView addSubview:_bannerScrollView];
    }
    return _bannerScrollView;
}

- (void)setUser:(NSDictionary *)user
{
    _user = user;
    
    self.iconBtn.layer.cornerRadius = self.iconBtn.height / 2;
    _iconBtn.clipsToBounds = true;
    
    userName.text = user[@"name"];
    [userStates setTitle:[NSString stringWithFormat:@"%@",user[@"job_condition_id_desc"]] forState:UIControlStateNormal];
    resumeProgress.text = [NSString stringWithFormat:@"简历完善度(%@)",user[@"resumeIntegrity"]];
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
    }];
}

- (IBAction)buttonClick:(UIButton *)sender {
    if (_mineHeaderButtonCallBack) {
        _mineHeaderButtonCallBack(sender.tag);
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHeaderIcon:) name:@"refreshHeaderIcon" object:nil];
    
    resumeProgress.userInteractionEnabled = true;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [resumeProgress addGestureRecognizer:tap];
    // Initialization code
}

- (void) tapClick:(UITapGestureRecognizer *)tap
{
    if (_mineHeaderStatusCallBack) {
        _mineHeaderStatusCallBack();
    }
}

- (void) reloadHeaderIcon:(NSNotification *) info
{
    NSDictionary * dic =  info.object;
    UserInfo.userInfo.image = dic[@"image"];
    [_iconBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KIMGURL,dic[@"image"]]] forState:UIControlStateNormal];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshHeaderIcon" object:nil];
}

@end
