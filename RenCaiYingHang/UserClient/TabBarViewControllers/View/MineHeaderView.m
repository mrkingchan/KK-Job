//
//  MineHeaderView.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/22.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "MineHeaderView.h"
#import "DYQBannerScrollView.h"

@interface MineHeaderView ()<DYQBannerScrollViewDelegate>

@property (nonatomic,strong) DYQBannerScrollView * bannerScrollView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;


@end

@implementation MineHeaderView
{
    __weak IBOutlet UILabel *userName;
    __weak IBOutlet UILabel *userStates;
    
}

- (DYQBannerScrollView *)bannerScrollView
{
    if (!_bannerScrollView) {
        _bannerScrollView = [[DYQBannerScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _bgView.bottom)];
        _bannerScrollView.pageControlPosition = PageControlPositionCenter;
        _bannerScrollView.timeInterval = 3;
        _bannerScrollView.delegate = self;
        [_bgView addSubview:_bannerScrollView];
    }
    return _bannerScrollView;
}

- (void)setUser:(NSDictionary *)user
{
    _user = user;
}

- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    self.bannerScrollView.imageUrls = _dataArr;
}

- (void)bannerScrollView:(DYQBannerScrollView *)bannerScrollView didSelectItemAtIndex:(NSInteger )index
{
    if (_mineHeaderClickCallBack) {
        _mineHeaderClickCallBack(index);
    }
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
