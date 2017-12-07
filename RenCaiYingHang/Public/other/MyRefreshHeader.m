//
//  MyRefreshHeader.m
//  TalentsBlank
//
//  Created by Macx on 2017/11/9.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "MyRefreshHeader.h"

@implementation MyRefreshHeader

#pragma mark - 重写父类的方法
- (void)prepare{
    [super prepare];
//    // 设置普通状态的动画图片
//    NSMutableArray * idleImages = [NSMutableArray array];
//
//    for (int i = 1; i <= 28; i++)
//    {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%02d", i]];
//        [idleImages addObject:image];
//    }
//
//    [self setImages:idleImages forState:MJRefreshStateIdle];
//
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    NSMutableArray *refreshingImages = [NSMutableArray array];
//    for (int i = 1; i<= 28; i++)
//    {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%02d", i]];
//        [refreshingImages addObject:image];
//    }
//
//    [self setImages:refreshingImages forState:MJRefreshStatePulling];
//
//    // 设置正在刷新状态的动画图片
//    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
//
//    //隐藏时间
//    self.lastUpdatedTimeLabel.hidden = YES;
//    //隐藏状态
//    self.stateLabel.hidden = YES;
}

@end
