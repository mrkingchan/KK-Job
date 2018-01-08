//
//  CompanyDetailViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/28.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "CompanyDetailViewController.h"

#import "RYShareView.h"

@interface CompanyDetailViewController ()

@property (nonatomic,copy) NSString * oldUrlString;

@end

@implementation CompanyDetailViewController

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

- (void)addRightBtn
{
    NSString * url = [NSString stringWithFormat:@"%@",self.webView.URL];
    if ([url rangeOfString:@"public/job/jobDetails"].location != NSNotFound) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE(@"shareToUser") style:UIBarButtonItemStylePlain target:self action:@selector(shareToUser)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:nil];
    }
}

/** 分享 */
- (void) shareToUser
{
    NSString * url = [NSString stringWithFormat:@"%@",self.webView.URL];
    NSString * urlString = [NSString stringWithFormat:@"http://weixin.rcyhj.com/public/job/jobDetails?%@",[url componentsSeparatedByString:@"?"][1]];
    NSString * datas = [url componentsSeparatedByString:@"="][1];
    NSString * idStr = [datas componentsSeparatedByString:@"&"][0];
    
    [NetWorkHelper getWithURLString:[NSString stringWithFormat:@"%@public/job/appJobDetails?datas=%@",KBaseURL,idStr] parameters:nil success:^(NSDictionary *data) {
        NSDictionary * rel = data[@"rel"];
        NSData * imageData =  [NSData
                               dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KIMGURL,rel[@"com_logo"]]]];
        UIImage * image = [UIImage imageWithData:imageData];
        if (![VerifyHelper empty:rel]) {
            RYShareView * share = [[RYShareView alloc] initWithFrame:[UIScreen mainScreen].bounds type:ShareJob];
            [[UIApplication sharedApplication].keyWindow addSubview:share];
            
            share.shareCallBack = ^(NSInteger index) {
                
                WXMediaMessage * message = [WXMediaMessage message];
                message.title = [NSString stringWithFormat:@"%@[%@k-%@k]",rel[@"job_name"],rel[@"salary_min"],rel[@"salary_max"]];
                message.description = [NSString stringWithFormat:@"面试奖:%@元,入职奖:%@元\r\n%@",@"10",rel[@"subsidy"],rel[@"com_name"]];
                [message setThumbImage:image];
                
                WXWebpageObject * webpageObject = [WXWebpageObject object];
                webpageObject.webpageUrl = urlString;
                message.mediaObject = webpageObject;
                
                SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
                req.bText = false;
                req.message  = message;
                req.scene =  index == 10 ? WXSceneSession : WXSceneTimeline;
                [WXApi sendReq:req];
            };
        }
    } failure:^(NSError *error) {
        
    }];
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
    if ([url rangeOfString:KBaseURL].location != NSNotFound) {
        if (![url isEqualToString:_oldUrlString]) {
            _oldUrlString = url;
            [self.webView  loadRequest:[NSURLRequest requestWithURL:navigationAction.request.URL]];
            decisionHandler(WKNavigationActionPolicyAllow);
        }else{
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }else{
       decisionHandler(WKNavigationActionPolicyCancel);
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];  
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
