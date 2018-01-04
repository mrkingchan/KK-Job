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
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
    [self addGestureRecognizer:tap];
    
    if (type == ShareUser) {
        _imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self addSubview:_imageView];
    }
    for (int i = 0; i < 2; i++) {
        UIButton * button = [UIFactory initButtonWithFrame:CGRectMake(kScreenWidth/2*i, kScreenHeight - 50, kScreenWidth/2, 50) image:UIIMAGE(@"AppIcon") cornerRadius:0 tag:10+i target:self action:@selector(buttonClick:)];
        [self addSubview:button];
    }
}

- (void)setImage:(UIImage *)image
{
    _image = image;
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
