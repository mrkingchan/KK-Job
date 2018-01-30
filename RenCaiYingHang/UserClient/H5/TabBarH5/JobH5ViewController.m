//
//  JobH5ViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "JobH5ViewController.h"

#import "JobDetailViewController.h"

#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface JobH5ViewController ()<BMKLocationServiceDelegate>

@property (nonatomic,copy) NSString * urlString ;

//定位
@property (nonatomic, strong)  BMKLocationService  * locService;

@end

@implementation JobH5ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - KNavBarHeight - KToolHeight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configLocationManager];
    
    [self locAction];
    
    self.webView.scrollView.mj_header = [MyRefreshHeader headerWithRefreshingBlock:^{
        [self.webView.scrollView.mj_header endRefreshing];
        [self reloadRequest];
    }];
}

- (void)reloadRequest
{
   [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString * url = [NSString stringWithFormat:@"%@",navigationAction.request.URL];
    if ([url rangeOfString:@"public/job/search"].location == NSNotFound) {
        JobDetailViewController * h5 = [[JobDetailViewController alloc] init];
        h5.url = [UtilityHelper addTokenForUrlSting:url];
        [self.navigationController pushViewController:h5 animated:true];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    [UIFactory addLoading];
    [self removeTapGesture];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    [UIFactory removeLoading];
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

/**  初始化定位 */
- (void)configLocationManager
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc] init];
    
    _locService.delegate = self;
    
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    _locService.distanceFilter = 10;
    
    //启动LocationService
    [_locService startUserLocationService];
}


/**  终止定位 */
- (void)cleanUpAction
{
    [self.locService stopUserLocationService];
}

/**  定位 */
- (void)locAction
{
    [self.locService startUserLocationService];
}

- (void)dealloc
{
    [self cleanUpAction];
    self.locService = nil;
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation.location.coordinate.latitude == 0)
    {
        [_locService startUserLocationService];
    }
    else
    {
        [self cleanUpAction];
        _urlString = [UtilityHelper addTokenForUrlSting:[NSString stringWithFormat:@"%@public/job/search?data=%@",KBaseURL,[NSString stringWithFormat:@"%f,%f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude]]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    }
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [self showAlertWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" appearanceProcess:^(EJAlertViewController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"取消").addActionDefaultTitle(@"设置");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, EJAlertViewController * _Nonnull alertSelf) {
        if (buttonIndex == 1) {
            //打开定位设置
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:settingsURL];
        }else{
            _urlString = [UtilityHelper addTokenForUrlSting:[NSString stringWithFormat:@"%@public/job/search?data=",KBaseURL]];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
        }
    }];
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
