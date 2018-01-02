//
//  HCH5ViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2018/1/2.
//  Copyright © 2018年 Macx. All rights reserved.
//

#import "HCH5ViewController.h"

@interface HCH5ViewController ()

@property (nonatomic,copy) NSString * oldUrlString;

@end

@implementation HCH5ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.webView.frame = CGRectMake(0, KNavBarHeight, kScreenWidth, kScreenHeight - KNavBarHeight);
    //标题
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _oldUrlString = self.url;
}

//点击返回的方法
- (void)backNative
{
    NSString * url = [NSString stringWithFormat:@"%@",self.webView.URL];
    NSString * origalUrl = [url componentsSeparatedByString:@"?"][0];
    if ([self.url rangeOfString:origalUrl].location != NSNotFound  || [url rangeOfString:@"appWxPay/remittancePayment?orderNumber="].location != NSNotFound) {
        [self.navigationController popToRootViewControllerAnimated:true];
    }else{
        //判断是否有上一层H5页面
        if ([self.webView canGoBack]) {
            //如果有则返回
            [self.webView goBack];
        }else{
            [self.navigationController popToRootViewControllerAnimated:true];
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //网页title
    if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.webView)
        {
            self.title = self.webView.title;
        }
    }
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

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"title"];
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
