//
//  ViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initView];
    [self requestImage];
}

- (void) initView
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:imageView];
    
    //这一步是获取上次网络请求下来的图片，如果存在就展示该图片，如果不存在就展示本地保存的名为test的图片
    NSData * imageData = [RYDefaults objectForKey:@"adImage"];
    if (imageData.length > 0) {
        imageView.image = [UIImage imageWithData:imageData];
        [self disMiss];
    }else{
        if (_pushCallBack) {
            _pushCallBack();
        }
    }
}

- (void) disMiss
{
    /** 模拟延时操作,如果是广告可以按实际操作来...*/
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_pushCallBack) {
            _pushCallBack();
        }
    });
}

- (void) requestImage
{
    [NetWorkHelper getWithURLString:[NSString stringWithFormat:@"%@securityCenter/appGuidePagePic",KBaseURL] parameters:nil success:^(NSDictionary *data) {
        NSDictionary * d = data[@"rel"];
        NSArray * arr = d[@"guidePagePic"];
        if (![VerifyHelper empty:arr]) {
            NSDictionary * dict = arr[0];
            NSString * picUrl = dict[@"picUrl"];
            NSData * imageData =  [NSData
                                   dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KIMGURL,picUrl]]];
            [RYDefaults setObject:imageData forKey:@"adImage"];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
