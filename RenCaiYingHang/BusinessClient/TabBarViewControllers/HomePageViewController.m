//
//  HomePageViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "HomePageViewController.h"

#import "PCCircleViewConst.h"

#import "AppPayRequest.h"

@interface HomePageViewController ()<WKScriptMessageHandler>

@property (nonatomic,assign) BOOL isFirst;

@property (nonatomic,copy) NSString * oldUrlString;

@end

@implementation HomePageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.webView.frame = CGRectMake(0, kStatusBarHeight, kScreenWidth, kScreenHeight - kStatusBarHeight);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadRequeset];
    [self regsiterMethod];
    _isFirst = false;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinPaySuccess:) name:@"WeXinPayCallBack" object:nil];
    
}

/** 加载h5 */
- (void) loadRequeset
{
    if (_isFinishComInfo) {
        NSString * jsonstr =   [@{@"token":UserInfo.userInfo.token,@"pkey":UserInfo.userInfo.pkey,@"comId":UserInfo.userInfo.comId} mj_JSONString];
        ;
        _oldUrlString = [NSString stringWithFormat:@"%@%@?token=%@",KBaseURL,@"identity/comUserIndex",[UtilityHelper encryptUseDES2:jsonstr key:DESKEY]];
    }else{
        _oldUrlString = [UtilityHelper addTokenForUrlSting:[NSString stringWithFormat:@"%@%@",KBaseURL,@"identity/company/regist/name"]];
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_oldUrlString]]];
}

/** 注册检测 */
- (void) regsiterMethod
{    
    [self.webConfiguration.userContentController addScriptMessageHandler:self name:@"comToUser"];
    [self.webConfiguration.userContentController addScriptMessageHandler:self name:@"comLoginOut"];
    [self.webConfiguration.userContentController addScriptMessageHandler:self name:@"comWeixinPay"];
    [self.webConfiguration.userContentController addScriptMessageHandler:self name:@"comAliPay"];
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    if (!_isFirst) {
        _isFirst = true;
        [UIFactory addLoading];
    }
    [self removeTapGesture];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    [self removeTapGesture];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [UIFactory removeLoading];
    [self removeTapGesture];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [UIFactory removeLoading];
    [self addTapGesture];
}

#pragma mark 跳转的操作
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString * url = [NSString stringWithFormat:@"%@",navigationAction.request.URL];
    if (![url isEqualToString:_oldUrlString]) {
        _oldUrlString = url;
        [self.webView  loadRequest:[NSURLRequest requestWithURL:navigationAction.request.URL]];
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"comToUser"]) {
        [self changeToUserClient];
    }else if ([message.name isEqualToString:@"comLoginOut"]){
        [self comLoginOutApp];
    }else if ([message.name isEqualToString:@"comWeixinPay"]){
        NSDictionary * d = message.body;
        NSDictionary * dic = d[@"rel"];
        [AppPayRequest weixinPayWithParamer:dic];
    }else if ([message.name isEqualToString:@"comAliPay"]){
        NSDictionary * d = message.body;
        NSString * str = d[@"rel"];
        [AppPayRequest aliPayWithParamer:str callback:^(NSDictionary *dic) {
            NSString * status = dic[@"resultStatus"];
            if ([status isEqualToString:@"9000"]) {
                [self payCallBack];
            }else{
                [self alertMessageWithViewController:self message:@"支付失败"];
            }
        }];
    }}

/** 切换到求职端 */
- (void) changeToUserClient
{
    if ([UserInfo.userInfo.reCode isEqualToString:@"X3333"]) {
        [UtilityHelper insertApp];
    }else{
        [UtilityHelper changeClient:2];
    }
}

/** 退出登录 **/
- (void) comLoginOutApp
{
    [UserInfo loginOut];
    [RYDefaults setObject:@"" forKey:[NSString stringWithFormat:UserCache]];
    [PCCircleViewConst saveGesture:nil Key:gestureFinalSaveKey];
    [[NSUserDefaults standardUserDefaults] setObject:@"close" forKey:@"setOn"];
    UIViewController * loginCtl = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[RYNavigationController alloc] initWithRootViewController:loginCtl];
}

#pragma mark 微信支付回掉
- (void)weixinPaySuccess:(NSNotification *) info
{
    [self payCallBack];
}

/** 支付提示 */
- (void) payCallBack
{
    [self showAlertWithTitle:@"支付成功" message:@"" appearanceProcess:^(EJAlertViewController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"确定");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, EJAlertViewController * _Nonnull alertSelf) {
        [self.navigationController popViewControllerAnimated:true];
    }];
}

- (void)dealloc{
    [self.webConfiguration.userContentController removeScriptMessageHandlerForName:@"comWeixinPay"];
    [self.webConfiguration.userContentController removeScriptMessageHandlerForName:@"comAliPay"];
    [self.webConfiguration.userContentController removeScriptMessageHandlerForName:@"comToUser"];
    [self.webConfiguration.userContentController removeScriptMessageHandlerForName:@"comLoginOut"];
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
