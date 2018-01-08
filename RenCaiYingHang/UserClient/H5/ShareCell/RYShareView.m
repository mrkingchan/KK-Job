//
//  RYShareView.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/29.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYShareView.h"

@interface RYShareView()

@property (nonatomic, strong) UIImageView * imageView;

@end

@implementation RYShareView

- (instancetype)initWithFrame:(CGRect)frame type:(RYShareViewType) type
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI:type];
    }
    return self;
}

- (void) initUI:(RYShareViewType) type
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
    [self addGestureRecognizer:tap];
    
    if (type == ShareUser) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageView];
    }
    
    UIView * bgView = [UIFactory initViewWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50) color:[UIColor lightGrayColor]];
    [self addSubview:bgView];
    
    for (int i = 0; i < 2; i++) {
        UIButton * button = [UIFactory initButtonWithFrame:CGRectMake((kScreenWidth/2 + 0.25)*i, 0, kScreenWidth/2 - 0.25, 50) image:UIIMAGE(i==0?@"share_friend":@"share_circle") cornerRadius:0 tag:10+i target:self action:@selector(buttonClick:)];
        [button setTitle:i==0?@"  微信好友":@"  微信朋友圈" forState:UIControlStateNormal];
        [button setBackgroundColor:kWhiteColor];
        [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        button.titleLabel.font = systemOfFont(16);
        [bgView addSubview:button];
    }
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    _imageView.center = self.center;
    _imageView.image = image;
}

- (void) buttonClick:(UIButton *) sender
{
    if (_shareCallBack) {
        _shareCallBack(sender.tag);
    }
    [self removeFromSuperview];
}

@end
