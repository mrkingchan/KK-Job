//
//  BankCardViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/27.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "BankCardViewController.h"

#import "IdentificationViewController.h"

@interface BankCardViewController ()<WKScriptMessageHandler>

@property (nonatomic,copy) NSString * oldUrlString;

@end

@implementation BankCardViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //标题
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // _oldUrlString = self.url;
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

//#pragma mark 跳转的操作
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    NSString * url = [NSString stringWithFormat:@"%@",navigationAction.request.URL];
//    if (![url isEqualToString:self.oldUrlString]) {
//        _oldUrlString = url;
//        [self.webView  loadRequest:[NSURLRequest requestWithURL:navigationAction.request.URL]];
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }else{
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
//}

/**
 与后台协商方法调用
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"unAuthIDCard"]) {
        //code...
        IdentificationViewController * certificationCtl = [[IdentificationViewController alloc] init];
        [self.navigationController pushViewController:certificationCtl animated:true];
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
