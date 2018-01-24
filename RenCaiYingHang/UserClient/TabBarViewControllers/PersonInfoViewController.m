//
//  PersonInfoViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2018/1/24.
//  Copyright © 2018年 Macx. All rights reserved.
//

#import "PersonInfoViewController.h"

#import "BankCardViewController.h"
#import "WalletViewController.h"
#import "SetupViewController.h"
#import "UploadResumeViewController.h"
#import "AgentViewController.h"

@interface PersonInfoViewController ()<WKScriptMessageHandler>

@end

@implementation PersonInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:animated];
    self.webView.frame = CGRectMake(0, kStatusBarHeight, kScreenWidth, kScreenHeight - KToolHeight - kStatusBarHeight);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self regsiterMethod];
    
    self.webView.scrollView.mj_header = [MyRefreshHeader headerWithRefreshingBlock:^{
        [self.webView.scrollView.mj_header endRefreshing];
        [self reloadRequest];
    }];
    
    [self reloadRequest];
    
    /** 修改了简历 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRequest) name:@"resumeStateChange" object:nil];

}

/** 注册检测 */
- (void) regsiterMethod
{
    [self.webConfiguration.userContentController addScriptMessageHandler:self name:@"userToCom"];
    [self.webConfiguration.userContentController addScriptMessageHandler:self name:@"jumpToSetup"];
    [self.webConfiguration.userContentController addScriptMessageHandler:self name:@"uploadResume"];
}

- (void) reloadRequest
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[UtilityHelper addUrlToken:@"identity/userIndex"]]]];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString * url = [NSString stringWithFormat:@"%@",navigationAction.request.URL];
    if (![url isEqualToString:[UtilityHelper addUrlToken:@"identity/userIndex"]]) {
        if ([url rangeOfString:@"apply/trans"].location != NSNotFound) {
            WalletViewController * h5 = [[WalletViewController alloc] init];
            h5.url = url;
            h5.jsMethodName = @"recharge";
            h5.type = 0;
            [self.navigationController pushViewController:h5 animated:true];
        }else if ([url rangeOfString:@"apply/bankcard"].location != NSNotFound){
            BankCardViewController * h5 = [[BankCardViewController alloc] init];
            h5.url = url;
            h5.jsMethodName = @"unAuthIDCard";
            [self.navigationController pushViewController:h5 animated:true];
        }else if ([url rangeOfString:@"apply/recommended"].location != NSNotFound){
            AgentViewController * h5 = [[AgentViewController alloc] init];
            h5.url = url;
            [self.navigationController pushViewController:h5 animated:true];
        }else{
            CommonH5Controller * h5 = [[CommonH5Controller alloc] init];
            h5.url = url;
            [self.navigationController pushViewController:h5 animated:true];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

/** 与后台协商方法调用 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"userToCom"]) {
        //进入企业
        // [self alertMessageWithViewController:self message:@"敬请期待"];
        [UtilityHelper changeClient:1];
    }
    else if ([message.name isEqualToString:@"jumpToSetup"])
    {
        [self.navigationController pushViewController:[[SetupViewController alloc] init] animated:true];
    }
    else if ([message.name isEqualToString:@"uploadResume"])
    {
        NSDictionary * dic = message.body;
        UploadResumeViewController * upload = [[UploadResumeViewController alloc] init];
        upload.resumeAddress = dic[@"image"];
        [self.navigationController pushViewController:upload animated:true];
    }
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    [UIFactory addLoading];
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

- (void)dealloc{
    [self.webConfiguration.userContentController removeScriptMessageHandlerForName:@"userToCom"];
    [self.webConfiguration.userContentController removeScriptMessageHandlerForName:@"jumpToSetup"];
    [self.webConfiguration.userContentController removeScriptMessageHandlerForName:@"uploadResume"];
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
