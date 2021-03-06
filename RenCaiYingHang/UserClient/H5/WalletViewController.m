//
//  WalletViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/25.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "WalletViewController.h"

#import "RechargeViewController.h"
#import "IdentificationViewController.h"

@interface WalletViewController ()<WKScriptMessageHandler>

@end

@implementation WalletViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //标题
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   [self.webConfiguration.userContentController addScriptMessageHandler:self name:@"unAuthIDCard"];
}

- (void)backNative
{
    if (_type == 1) {
        [self.navigationController popToRootViewControllerAnimated:true];
    }else{
        NSString * url = [NSString stringWithFormat:@"%@",self.webView.URL];
        NSString * origalUrl = [url componentsSeparatedByString:@"?"][0];
        if ([self.url rangeOfString:origalUrl].location != NSNotFound  || [url rangeOfString:@"apply/trans/withDrawalsResult"].location != NSNotFound) {
            [self.navigationController popViewControllerAnimated:true];
        }else{
            //判断是否有上一层H5页面
            if ([self.webView canGoBack]) {
                //如果有则返回
                [self.webView goBack];
            }else{
                [self.navigationController popViewControllerAnimated:true];
            }
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

/** 与后台协商方法调用 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"recharge"]) {
        RechargeViewController * recharge = [[RechargeViewController alloc] init];
        [self.navigationController pushViewController:recharge animated:true];
    } else if ([message.name isEqualToString:@"unAuthIDCard"]){
        IdentificationViewController * certificationCtl = [[IdentificationViewController alloc] init];
        [self.navigationController pushViewController:certificationCtl animated:true];
    }
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"title"];
     [self.webConfiguration.userContentController removeScriptMessageHandlerForName:@"unAuthIDCard"];
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
