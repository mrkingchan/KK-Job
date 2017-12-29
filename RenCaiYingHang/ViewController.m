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
}

- (void) initView
{
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:imageView];
    
    imageView.image = UIIMAGE(@"bg");
    
    [UIView animateKeyframesWithDuration:1.5f delay:3.0f options:UIViewKeyframeAnimationOptionCalculationModeDiscrete animations:^{
        
    } completion:^(BOOL finished) {
        if (_pushCallBack) {
            _pushCallBack();
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
