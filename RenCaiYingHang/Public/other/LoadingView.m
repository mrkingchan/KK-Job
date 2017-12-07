//
//  LoadingView.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView
{
    UIActivityIndicatorView *indicatorView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    if (self)
    {
        [indicatorView removeFromSuperview];
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.frame = CGRectMake(0, 0, 80, 80);
        indicatorView.layer.cornerRadius = 5;
        indicatorView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicatorView.center = self.center;
        [indicatorView startAnimating];
        [self addSubview:indicatorView];
        [indicatorView startAnimating];
    }
    return self;
}

- (void) show
{
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
}

- (void) dismiss
{
    [self removeFromSuperview];
}

@end
