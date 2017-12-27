//
//  ScanSucessViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/27.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ScanSucessViewController.h"

#import "WalletViewController.h"

@interface ScanSucessViewController ()

@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, strong) UIButton *  balanceBtn;

@end

@implementation ScanSucessViewController

- (UIImageView *)imageView
{
    if (!_imageView) {
        
    }
    return _imageView;
}

- (UIButton *)balanceBtn
{
    if (!_balanceBtn) {
        
    }
    return _balanceBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE(@"nav_back") style:UIBarButtonItemStylePlain target:self action:@selector(backNative)];
}

- (void) backNative
{
    //去钱包
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
