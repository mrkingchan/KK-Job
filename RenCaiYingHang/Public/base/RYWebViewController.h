//
//  RYWebViewController.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYViewController.h"

#import <WebKit/WebKit.h>

@interface RYWebViewController : RYViewController

@property (nonatomic,strong) WKWebView * webView;

@property (nonatomic, copy) UIColor *progressViewColor;

@property (nonatomic,strong) WKWebViewConfiguration * webConfiguration;

@property (nonatomic, copy) NSString * url;

/**
 有多个可以设置成数组
 */
@property (nonatomic, copy) NSString * jsMethodName;

//点击返回的方法
- (void)backNative;

- (void) addRightBtn;

@end
