//
//  JobH5ViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "JobH5ViewController.h"

#import "JobDetailViewController.h"

#import <AMapLocationKit/AMapLocationKit.h>

@interface JobH5ViewController ()<AMapLocationManagerDelegate>

@property (nonatomic,copy) NSString * urlString ;

@property (nonatomic, strong) AMapLocationManager *locationManager;

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
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString * url = [NSString stringWithFormat:@"%@",navigationAction.request.URL];
    if (![url isEqualToString:_urlString]) {
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
    [XYQProgressHUD showMessage:@"加载中..."];
    [self removeTapGesture];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    [XYQProgressHUD hideHUD];
    [self removeTapGesture];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [XYQProgressHUD hideHUD];
    [self removeTapGesture];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [XYQProgressHUD hideHUD];
    [self addTapGesture];
}

/**  初始化定位 */
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:10];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:5];
    
    //设置开启虚拟定位风险监测，可以根据需要开启
    [self.locationManager setDetectRiskOfFakeLocation:NO];
    
    //设置允许连续定位逆地理
    [self.locationManager setLocatingWithReGeocode:YES];
}


/**  终止定位 */
- (void)cleanUpAction
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
}

/**  定位 */
- (void)locAction
{
    //开始进行连续定位
    [self.locationManager startUpdatingLocation];
}

#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    [self showAlertWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" appearanceProcess:^(EJAlertViewController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"取消").addActionDefaultTitle(@"设置");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, EJAlertViewController * _Nonnull alertSelf) {
        if (buttonIndex == 1) {
            //打开定位设置
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:settingsURL];
        }
    }];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
   // NSLog(@"location:{lat:%f; lon:%f; accuracy:%f; reGeocode:%@}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy, reGeocode.formattedAddress);
    [self cleanUpAction];
    NSString * jsonstr =   [@{@"lat":@(location.coordinate.latitude),@"lon":@(location.coordinate.longitude)} mj_JSONString];
    ;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[UtilityHelper addTokenForUrlSting:[NSString stringWithFormat:@"%@public/job/search?data=%@",KBaseURL,[UtilityHelper decryptUseDES2:jsonstr key:DESKEY]]]]]];
    _urlString = [UtilityHelper addTokenForUrlSting:[NSString stringWithFormat:@"%@public/job/search?data=%@",KBaseURL,[UtilityHelper decryptUseDES2:jsonstr key:DESKEY]]];
}


- (void)dealloc
{
    [self cleanUpAction];
    self.locationManager = nil;
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
