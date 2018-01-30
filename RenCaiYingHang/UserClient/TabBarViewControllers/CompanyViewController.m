//
//  CompanyViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "CompanyViewController.h"

#import "CompanyDetailViewController.h"

@interface CompanyViewController ()

@end

@implementation CompanyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - KNavBarHeight - KToolHeight);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.webView.scrollView.mj_header = [MyRefreshHeader headerWithRefreshingBlock:^{
        [self.webView.scrollView.mj_header endRefreshing];
        [self reloadRequest];
    }];
    [self reloadRequest];
}

- (void) reloadRequest
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[UtilityHelper addUrlToken:CompanyList]]]];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString * url = [NSString stringWithFormat:@"%@",navigationAction.request.URL];
    if (![url isEqualToString:[UtilityHelper addUrlToken:CompanyList]]) {
        CompanyDetailViewController * h5 = [[CompanyDetailViewController alloc] init];
        h5.url = [UtilityHelper addTokenForUrlSting:url];
        [self.navigationController pushViewController:h5 animated:true];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    //[self isConnectNetWork];
    [UIFactory addLoading];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
   // [UIFactory removeLoading];
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
