//
//  RYWebViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYWebViewController.h"

#import "CompanyViewController.h"
#import "DropInBoxViewController.h"

@interface RYWebViewController ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>

@property (nonatomic,strong) LoadingView * loading;

@property (nonatomic,strong) UIProgressView * progressView;

//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;

@end

@implementation RYWebViewController

- (LoadingView *)loading
{
    if (!_loading) {
        _loading = [[LoadingView alloc] initWithFrame:CGRectZero];
    }
    return _loading;
}

- (WKWebViewConfiguration *)webConfiguration
{
    if (!_webConfiguration) {
        _webConfiguration = [[WKWebViewConfiguration alloc] init];
        _webConfiguration.userContentController = [[WKUserContentController alloc] init];
    }
    return _webConfiguration;
}

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, KNavBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - KNavBarHeight) configuration:self.webConfiguration];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.bounces = false;
        _webView.scrollView.showsVerticalScrollIndicator = false;
        [_webView setAllowsBackForwardNavigationGestures:true];
        [self.view addSubview:self.webView];
    }
    return _webView;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.tintColor = nil;
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.frame = CGRectMake(0, 2, self.view.bounds.size.width, 3.0);
        [self.webView addSubview:_progressView];
    }
    return _progressView;
}

- (void)setProgressViewColor:(UIColor *)progressViewColor
{
    _progressViewColor = progressViewColor;
    self.progressView.tintColor = progressViewColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //监控进度
   // [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //适配iOS11
    if (@available(iOS 11.0, *)){
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//     AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
//    if (netManager.isReachable) {
//        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
//    }
}

- (void)addLeftButton
{
    if ([self isKindOfClass:[CompanyViewController class]] || [self isKindOfClass:[DropInBoxViewController class]]) {
        return;
    }
    self.navigationItem.leftBarButtonItem = self.backItem;
    //判断是否有上一层H5页面
//    if ([self.webView canGoBack]) {
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
//        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
//    }
//    else{
//        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
//        self.navigationItem.leftBarButtonItem = self.backItem;
//    }
}

/** 添加分享按钮 */
-(void)addRightBtn
{
    
}

//点击返回的方法
- (void)backNative
{
    NSString * url = [NSString stringWithFormat:@"%@",self.webView.URL];
    NSString * origalUrl = [url componentsSeparatedByString:@"?"][0];
    if ([self.url rangeOfString:origalUrl].location != NSNotFound  || [url rangeOfString:@"apply/trans/withDrawalsResult"].location != NSNotFound) {
        [self closeNative];
    }else{
        //判断是否有上一层H5页面
        if ([self.webView canGoBack]) {
            //如果有则返回
            [self.webView goBack];
        }else{
            [self closeNative];
        }
    }
}

//关闭H5页面，直接回到原生页面
- (void)closeNative
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - init
- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE(@"nav_back") style:UIBarButtonItemStylePlain target:self action:@selector(backNative)];
    }
    return _backItem;
}

//- (UIBarButtonItem *)closeItem
//{
//    if (!_closeItem) {
//        _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeNative)];
//        _closeItem.tintColor = [UIColor blackColor];
//    }
//    return _closeItem;
//}

- (void)setJsMethodName:(NSString *)jsMethodName
{
    _jsMethodName = jsMethodName;
    //注册方法
    [self.webConfiguration.userContentController addScriptMessageHandler:self name:jsMethodName];
}

- (void)setUrl:(NSString *)url
{
    _url = url;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark --进度条
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //加载进度值
//    if ([keyPath isEqualToString:@"estimatedProgress"])
//    {
//        if (object == self.webView)
//        {
//            [self changeProgressLength];
//        }
//    }
//    //网页title
//    if ([keyPath isEqualToString:@"title"])
//    {
//        if (object == self.webView)
//        {
//            self.title = self.webView.title;
//        }
//    }
}

/**
 进度条
 */
- (void) changeProgressLength
{
    [self.progressView setAlpha:1.0f];
    [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
    if(self.webView.estimatedProgress >= 1.0f)
    {
        [UIView animateWithDuration:0.5f
                              delay:0.3f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [self.progressView setAlpha:0.0f];
                         }
                         completion:^(BOOL finished) {
                             [self.progressView setProgress:0.0f animated:NO];
                         }];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    //[self.loading show];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
   // [self.loading dismiss];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self addLeftButton];
    [self addRightBtn];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self addLeftButton];
    [self addRightBtn];
   // [self.loading dismiss];
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"didStartProvisionalNavigation");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    
}

/**
 与后台协商方法调用
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:self.jsMethodName]) {
        //code...
    }
}

- (void)dealloc{
    [self.webConfiguration.userContentController removeScriptMessageHandlerForName:self.jsMethodName];
   // [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
