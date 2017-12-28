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
        _imageView = [[UIImageView alloc] initWithImage:UIIMAGE(@"ss01")];
        [_imageView setFrame:CGRectMake(kScreenWidth/4, kScreenHeight * 0.2, kScreenWidth/2, kScreenWidth/2)];
        _imageView.contentMode =  UIViewContentModeScaleAspectFit;
        [self.view addSubview:_imageView];
        
        UIImageView * img2 = [[UIImageView alloc] initWithImage:UIIMAGE(@"ss02")];
        [img2 setFrame:CGRectMake(_imageView.x + 20,_imageView.y + 20, kScreenWidth/2 - 40, kScreenWidth/2 - 40)];
        img2.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:img2];
        [img2 rotate360DegreeWithImageView:false];
        
        UIImageView * img3 = [[UIImageView alloc] initWithImage:UIIMAGE(@"ss03")];
        [img3 setFrame:CGRectMake(img2.x + 20, img2.y + 20, img2.width - 40, img2.height - 40)];
        [self.view addSubview:img3];
        
        UILabel * label = [UIFactory initLableWithFrame:CGRectMake(img3.x, img3.y, img3.width, 30) title:@"10元" textColor:kWhiteColor font:[UIFont boldSystemFontOfSize:20] textAlignment:1];
        label.center = img3.center;
        [self.view addSubview:label];
    }
    return _imageView;
}

- (UIButton *)balanceBtn
{
    if (!_balanceBtn) {
        _balanceBtn = [UIFactory initButtonWithFrame:CGRectMake(kScreenWidth * 0.15, self.imageView.bottom + 50, kScreenWidth * 0.7, 40) title:@"查看余额" textColor:kWhiteColor font:systemOfFont(16) cornerRadius:0 tag:10 target:self action:@selector(gotoWallet)];
        _balanceBtn.backgroundColor = [UIColor redColor];
    }
    return _balanceBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"扫码成功";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE(@"nav_back") style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    [self.imageView rotate360DegreeWithImageView:true];
    [self.view addSubview:self.balanceBtn];
}

- (void) pop
{
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void) gotoWallet
{
    //去钱包
    WalletViewController * h5 = [[WalletViewController alloc] init];
    h5.url = [UtilityHelper addUrlToken:@"apply/trans"];
    h5.type = 1;
    [self.navigationController pushViewController:h5 animated:true];
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
