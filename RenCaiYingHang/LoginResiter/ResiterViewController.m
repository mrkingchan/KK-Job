//
//  ResiterViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ResiterViewController.h"

@interface ResiterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *regsiterBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) NSInteger time;

@end

@implementation ResiterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stop];
    [self.navigationController setNavigationBarHidden:false animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

/** 密码登陆 */
- (IBAction)returnBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

/** 是否遵守协议 **/
- (IBAction)isAgreeProtocol:(UIButton *)sender {
    sender.selected = !sender.selected;
    _regsiterBtn.backgroundColor = sender.selected ? [UIColor redColor] : Color235;
    _regsiterBtn.enabled = sender.selected;
}

/** 获取验证码 */
- (IBAction)gainAuthCode:(UIButton *)sender {
    _time = KAuthCodeSecond;
    [self countDown];
}

/** 注册成功直接登陆 */
- (IBAction)insertApp:(UIButton *)sender {
    /** 默认进入登录页面 **/
    [UIApplication sharedApplication].keyWindow.rootViewController = [[RYTabBarController alloc] init];
    [[UIApplication sharedApplication].keyWindow.layer transitionWithAnimType:TransitionAnimTypeRippleEffect subType:TransitionSubtypesFromRamdom curve:TransitionCurveRamdom duration:1.0f];
}

/** 跳转到协议 */
- (IBAction)pushToProtocolH5:(UIButton *)sender {
    RYWebViewController * html = [[RYWebViewController alloc] init];
    html.url = @"https://www.baidu.com";
    html.jsMethodName = @"test";
    html.progressViewColor = [UIColor redColor];
    [self.navigationController pushViewController:html animated:YES];
}

/** 开始读秒 */
- (void) countDown
{
    self.codeBtn.enabled = NO;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%zd秒", _time] forState:UIControlStateNormal];
    self.timer =[NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(timeAction:)
                                               userInfo:nil
                                                repeats:YES];
}

- (void)timeAction:(NSTimer *)timer
{
    --_time ;
    
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%zd秒", _time] forState:UIControlStateNormal];
    
    if (_time == 0) {
        [self stop];
    }
}

/**
 关掉定时器
 */
- (void)stop
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    self.codeBtn.enabled = true;
    [self.codeBtn setTitle:@"验证码" forState:UIControlStateNormal];
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
