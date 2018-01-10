//
//  CommonH5Controller.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "CommonH5Controller.h"

@interface CommonH5Controller ()

@property (nonatomic,copy) NSString * oldUrlString;

@end

@implementation CommonH5Controller

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
    
    if ([_oldUrlString containsString:@"apply/resume/modifyRes"] != NSNotFound) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resumeStateChange" object:nil];
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
//        CommonH5Controller * h5 = [[CommonH5Controller alloc] init];
//        h5.url = [UtilityHelper addTokenForUrlSting:url];
//        [self.navigationController pushViewController:h5 animated:true];
//        decisionHandler(WKNavigationActionPolicyCancel);
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
