//
//  CompanyCenterViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "CompanyCenterViewController.h"

@interface CompanyCenterViewController ()

@end

@implementation CompanyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton * button = [UIFactory initButtonWithFrame:CGRectMake(100, 100, kScreenWidth-200, 40) title:@"切到个人版" textColor:[UIColor darkTextColor] font:systemOfFont(16) cornerRadius:20 tag:10 target:self action:@selector(senderClick:)];
    [self.view addSubview:button];
}

/** 切换到个人版 **/
- (void) senderClick:(UIButton *)sender
{
    /** 默认进入雷达页面 **/
    [UIApplication sharedApplication].keyWindow.rootViewController = [[RYTabBarController alloc] init];
    [[UIApplication sharedApplication].keyWindow.layer transitionWithAnimType:TransitionAnimTypeRippleEffect subType:TransitionSubtypesFromRamdom curve:TransitionCurveRamdom duration:1.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
