//
//  UIFactory.h
//  TalentsBlank
//
//  Created by Macx on 2017/11/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIFactory : NSObject

/*
 没图按钮
 */
+ (UIButton *) initButtonWithFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor font :(UIFont *) font cornerRadius:(CGFloat)cornerRadius tag:(NSInteger)tag  target:(id)target action:(SEL)action;

/*
 没图按钮带框
 */
+ (UIButton *) initBorderButtonWithFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor font :(UIFont *) font cornerRadius:(CGFloat)cornerRadius bgColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat) borderWidth tag:(NSInteger)tag  target:(id)target action:(SEL)action;

/*
 图按钮
 */
+ (UIButton *) initButtonWithFrame:(CGRect)frame image:(UIImage *)image cornerRadius:(CGFloat)cornerRadius tag:(NSInteger)tag  target:(id)target action:(SEL)action;

/*
 文本
 */
+ (UILabel *) initLableWithFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor font :(UIFont *) font  textAlignment:(NSTextAlignment)textAlignment;

/*
 表格
 */
+ (UITableView *) initTableViewWithFrame:(CGRect)rect style:(UITableViewStyle)style delegate:(id)delegate;

/*
 视图
 */
+ (UIView *)initViewWithFrame:(CGRect)rect color:(UIColor *)color;

@end
