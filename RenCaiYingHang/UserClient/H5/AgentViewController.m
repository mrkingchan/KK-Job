//
//  AgentViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/28.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "AgentViewController.h"

#import "RYShareView.h"

@interface AgentViewController ()

@end

@implementation AgentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.webView.frame = CGRectMake(0, KNavBarHeight, kScreenWidth, kScreenHeight - KNavBarHeight);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"人才经纪人";
    self.jsMethodName = @"shareToUser";
}

/**
 与后台协商方法调用
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"shareToUser"]) {
        //code...
        NSDictionary * d = message.body;
        UIImage * image = [UtilityHelper composeImg:UIIMAGE(@"share") img1:[UtilityHelper qrImageForString:d[@"url"] imageSize:80 logoImageSize:0]];
        RYShareView * share = [[RYShareView alloc] initWithFrame:[UIScreen mainScreen].bounds type:ShareUser];
        share.image = image;
        [[UIApplication sharedApplication].keyWindow addSubview:share];
        
        share.shareCallBack = ^(NSInteger index) {

            WXMediaMessage * message = [WXMediaMessage message];
            [message setThumbImage:image];

            WXImageObject * imageObject = [WXImageObject object];
            imageObject.imageData = UIImagePNGRepresentation(image);
            message.mediaObject=imageObject;

            SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
            req.bText = false;
            req.message  = message;
            req.scene =  index == 10 ? WXSceneSession : WXSceneTimeline;
            [WXApi sendReq:req];
        };
    }
}

- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 1.0);
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
