//
//  JobH5ViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "JobH5ViewController.h"

#import "JobDetailViewController.h"

@interface JobH5ViewController ()

@property (nonatomic,copy) NSString * urlString ;

@end

@implementation JobH5ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - KNavBarHeight - KToolHeight);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString * jsonstr =   [@{@"lat":@(0.00),@"lon":@(0.00)} mj_JSONString];
    ;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[UtilityHelper addTokenForUrlSting:[NSString stringWithFormat:@"%@public/job/search?data=%@",KBaseURL,[UtilityHelper decryptUseDES2:jsonstr key:DESKEY]]]]]];
    _urlString = [UtilityHelper addTokenForUrlSting:[NSString stringWithFormat:@"%@public/job/search?data=%@",KBaseURL,[UtilityHelper decryptUseDES2:jsonstr key:DESKEY]]];
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
