//
//  AgentViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/28.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "AgentViewController.h"

#import "RYShareView.h"
#import "HImageUtility.h"

@interface AgentViewController ()

@end

@implementation AgentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"人才经纪人";
    self.jsMethodName = @"shareToUser";
}

/** 与后台协商方法调用 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"shareToUser"]) {
        //code... UserInfo.userInfo.name 
        NSDictionary * d = message.body;
        ;
        //压缩图
        UIImage * thumimage = [UtilityHelper composeImg:UIIMAGE(@"share") img1:[UtilityHelper qrImageForString:d[@"url"] imageSize:60 logoImageSize:0]];
        UIImage * finalImage = [HImageUtility imageWithText:[NSString stringWithFormat:@"%@邀请你一起",d[@"name"]]
                                    textFont:14
                                   textColor:kNavBarTintColor
                                   textFrame:CGRectMake(130, thumimage.size.height - 100, 150, 20)
                                 originImage:thumimage
                      imageLocationViewFrame:CGRectMake(0, 0, thumimage.size.width, thumimage.size.height)];
        //高清图
        UIImage * bigImage = [UtilityHelper composeImg:UIIMAGE(@"shareBig") img1:[UtilityHelper qrImageForString:d[@"url"] imageSize:100 logoImageSize:0]];
        UIImage * finBigImage = [HImageUtility imageWithText:[NSString stringWithFormat:@"%@邀请你一起",d[@"name"]]
                                                   textFont:20
                                                  textColor:kNavBarTintColor
                                                  textFrame:CGRectMake(260, bigImage.size.height - 200, 150, 20)
                                                originImage:bigImage
                                     imageLocationViewFrame:CGRectMake(0, 0, bigImage.size.width, bigImage.size.height)];
        
        RYShareView * share = [[RYShareView alloc] initWithFrame:[UIScreen mainScreen].bounds type:ShareUser];
        share.image = finalImage;
        [[UIFactory getKeyWindow] addSubview:share];
        
        share.shareCallBack = ^(NSInteger index) {

            WXMediaMessage * message = [WXMediaMessage message];
            [message setThumbImage:finalImage];

            WXImageObject * imageObject = [WXImageObject object];
            //高清图
            imageObject.imageData = UIImagePNGRepresentation(finBigImage);
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
