//
//  HomePageViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "HomePageViewController.h"

@interface HomePageViewController ()<WKScriptMessageHandler>

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
}

/** 加载h5 */
- (void) loadRequeset
{
    _oldUrlString = [UtilityHelper addTokenForUrlSting:[NSString stringWithFormat:@"%@%@",KBaseURL,@"identity/company/regist/name"]];
    if (UserInfo.userInfo.isFinishComInfo) {
        NSString * jsonstr =   [@{@"token":UserInfo.userInfo.token,@"pkey":UserInfo.userInfo.pkey,@"comId":UserInfo.userInfo.com_id} mj_JSONString];
        ;
        _oldUrlString = [NSString stringWithFormat:@"%@%@?token=%@",KBaseURL,@"identity/comUserIndex",[UtilityHelper encryptUseDES2:jsonstr key:DESKEY]];
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_oldUrlString]]];
}

/** 注册检测 */
- (void) regsiterMethod
{
     [self.webConfiguration.userContentController addScriptMessageHandler:self name:@"comToUser"];
    [self.webConfiguration.userContentController addScriptMessageHandler:self name:@"comLoginOut"];
    [self.webConfiguration.userContentController addScriptMessageHandler:self name:@"comAppPay"];
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
        //NSDictionary * d = message.body;
    }else if ([message.name isEqualToString:@"comAppPay"]){
        
    }
}

- (void) changeToUserClient
{
    UserInfo.userInfo.isComUser = 1;
    NSDictionary * d = UserInfo.userInfo.mj_keyValues;
    NSData * dataUser  = [NSKeyedArchiver archivedDataWithRootObject:d];
    [RYDefaults setObject:dataUser forKey:UserCache];
    
    if (UserInfo.userInfo.isFinishBaseInfo) {
        [UtilityHelper jumpDifferentApp:true window:[UIApplication sharedApplication].keyWindow];
    }else{
        [UtilityHelper insertApp];
    }}

- (void)dealloc{
    [self.webConfiguration.userContentController removeScriptMessageHandlerForName:@"comAppPay"];
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
