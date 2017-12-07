//
//  RYTabBar.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYTabBar.h"

@interface RYTabBar()

@property (nonatomic, strong) UIButton *middleBtn;

@end

@implementation RYTabBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat w = self.bounds.size.width/5.0;
    
    UIButton *sendBtn = [[UIButton alloc] init];
    [sendBtn setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(didClickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.adjustsImageWhenHighlighted = NO;
    sendBtn.size = CGSizeMake(w, 70);
    sendBtn.centerX = self.width / 2;
    sendBtn.centerY = 10;
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:sendBtn];
    self.middleBtn = sendBtn;
    
    // [sendBtn setImagePositionWithType:SSImagePositionTypeTop spacing:4];
    // 其他位置按钮
    NSUInteger count = self.subviews.count;
    for (NSUInteger i = 0 , j = 0; i < count; i++)
    {
        UIView *view = self.subviews[i];
        Class class = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:class])
        {
            view.width = self.width / 5.0;
            view.x = self.width * j / 5.0;
            j++;
            if (j == 2)
            {
                j++;
            }
        }
    }
    
}

// 扫一扫
- (void)didClickPublishBtn:(UIButton*)sender {
    if (self.didMiddBtn) {
        self.didMiddBtn();
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.isHidden == NO)
    {
        CGPoint newP = [self convertPoint:point toView:self.middleBtn];
        if ( [self.middleBtn pointInside:newP withEvent:event])
        {
            return self.middleBtn;
        }else
        {
            return [super hitTest:point withEvent:event];
        }
    }
    else
    {
        return [super hitTest:point withEvent:event];
    }
}

@end
