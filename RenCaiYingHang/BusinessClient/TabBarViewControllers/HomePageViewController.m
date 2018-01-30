//
//  HomePageViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "HomePageViewController.h"

#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import "AppPayRequest.h"

#import "RYShareView.h"

@interface HomePageViewController ()<WKScriptMessageHandler,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
//定位
@property (nonatomic, strong)  BMKLocationService  * locService;

@property (nonatomic, strong)  BMKGeoCodeSearch * geocodesearch;

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
        [self configLocationManager];
        [self locAction];
        NSString * jsonstr =   [@{@"token":UserInfo.userInfo.token,@"pkey":UserInfo.userInfo.pkey,@"comId":UserInfo.userInfo.comId} mj_JSONString];
        ;
        _oldUrlString = [NSString stringWithFormat:@"%@%@?token=%@",KBaseURL,@"identity/comUserIndex",[UtilityHelper encryptUseDES2:jsonstr key:DESKEY]];
    }else{
        _oldUrlString = [UtilityHelper addTokenForUrlSting:[NSString stringWithFormat:@"%@%@",KBaseURL,@"identity/company/regist/name"]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_oldUrlString]]];
    }
}

/** 注册检测 */
- (void) regsiterMethod
{    
    [self.webConfiguration.userContentController addScriptMessageHandler:self name:@"comToUser"];
    [self.webConfiguration.userContentController addScriptMessageHandler:self name:@"comLoginOut"];
    [self.webConfiguration.userContentController addScriptMessageHandler:self name:@"comWeixinPay"];
    [self.webConfiguration.userContentController addScriptMessageHandler:self name:@"comAliPay"];
    [self.webConfiguration.userContentController addScriptMessageHandler:self name:@"comShare"];
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
    decisionHandler(WKNavigationActionPolicyAllow);
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
    }else if ([message.name isEqualToString:@"comShare"]){

        NSDictionary * rel = message.body;
        NSData * imageData =  [NSData
                               dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KIMGURL,rel[@"comLogo"]]]];
        UIImage * image = [UIImage imageWithData:imageData];

        RYShareView * share = [[RYShareView alloc] initWithFrame:[UIScreen mainScreen].bounds type:ShareJob];
        [[UIFactory getKeyWindow] addSubview:share];

        share.shareCallBack = ^(NSInteger index) {

            WXMediaMessage * message = [WXMediaMessage message];
            message.title = [NSString stringWithFormat:@"%@[%@k-%@k]",rel[@"jobName"],rel[@"salaryMin"],rel[@"salaryMax"]];
            message.description = [NSString stringWithFormat:@"面试奖:%@元,入职奖:%@元\r\n%@",@"10",rel[@"defSubsidy"],rel[@"comName"]];
            [message setThumbImage:image];

            WXWebpageObject * webpageObject = [WXWebpageObject object];
            webpageObject.webpageUrl = rel[@"url"];
            message.mediaObject = webpageObject;

            SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
            req.bText = false;
            req.message  = message;
            req.scene =  index == 10 ? WXSceneSession : WXSceneTimeline;
            [WXApi sendReq:req];
        };
    }
}

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
   
    UIViewController * loginCtl = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    [UIFactory getKeyWindow].rootViewController = [[RYNavigationController alloc] initWithRootViewController:loginCtl];
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
    [self.webConfiguration.userContentController removeScriptMessageHandlerForName:@"comShare"];
    [self cleanUpAction];
    self.locService = nil;
    _geocodesearch.delegate = nil; // 不用时，置nil
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
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
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
        BMKReverseGeoCodeOption *reverseOption = [[BMKReverseGeoCodeOption alloc] init];
        //2.给反向地理编码选项对象的坐标点赋值
        reverseOption.reverseGeoPoint = userLocation.location.coordinate;
        //3.执行反地理编码
        [_geocodesearch reverseGeoCode:reverseOption];
    }
}

/** 反地理编码 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    _oldUrlString = [[NSString stringWithFormat:@"%@&city=%@",_oldUrlString,result.addressDetail.city] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_oldUrlString]]];
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
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_oldUrlString]]];
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
