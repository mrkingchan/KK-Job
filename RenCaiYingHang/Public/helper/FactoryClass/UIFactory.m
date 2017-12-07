//
//  UIFactory.m
//  TalentsBlank
//
//  Created by Macx on 2017/11/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "UIFactory.h"

@implementation UIFactory

/*
 没图按钮
 */
+ (UIButton *) initButtonWithFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor font :(UIFont *) font cornerRadius:(CGFloat)cornerRadius tag:(NSInteger)tag  target:(id)target action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    //处理掉高亮下灰色
    [button setAdjustsImageWhenHighlighted:NO];
    button.titleLabel.font = font;
    button.layer.cornerRadius = cornerRadius;
    button.tag = tag;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/*
 没图按钮带框
 */
+ (UIButton *) initBorderButtonWithFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor font :(UIFont *) font cornerRadius:(CGFloat)cornerRadius bgColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat) borderWidth tag:(NSInteger)tag  target:(id)target action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    //处理掉高亮下灰色
    [button setAdjustsImageWhenHighlighted:NO];
    button.titleLabel.font = font;
    button.layer.cornerRadius = cornerRadius;
    button.layer.borderWidth = borderWidth;
    button.layer.borderColor = borderColor.CGColor;
    button.backgroundColor = bgColor;
    button.tag = tag;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/*
 有图按钮
 */
+ (UIButton *) initButtonWithFrame:(CGRect)frame image:(UIImage *)image cornerRadius:(CGFloat)cornerRadius tag:(NSInteger)tag  target:(id)target action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setImage:image forState:UIControlStateNormal];
    //处理掉高亮下灰色
    [button setAdjustsImageWhenHighlighted:NO];
    button.layer.cornerRadius = cornerRadius;
    button.tag = tag;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/*
 文本
 */
+ (UILabel *) initLableWithFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor font :(UIFont *) font  textAlignment:(NSTextAlignment)textAlignment
{
    UILabel * label = [[UILabel alloc] init];
    [label setFrame:frame];
    [label setText:title];
    [label setTextColor:textColor];
    [label setFont:font];
    [label setTextAlignment:textAlignment];
    return label;
}

/*
 表格
 */
+ (UITableView *) initTableViewWithFrame:(CGRect)rect style:(UITableViewStyle)style delegate:(id)delegate
{
    UITableView * tableView = [[UITableView alloc] initWithFrame:rect style:style];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableFooterView = [UIView new];
    return tableView;
}

/*
 视图
 */
+ (UIView *)initViewWithFrame:(CGRect)rect color:(UIColor *)color
{
    UIView * currentView = [[UIView alloc] initWithFrame:rect];
    currentView.backgroundColor = color;
    return currentView;
}

@end
