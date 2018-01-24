//
//  YWRoundAnnotationView.m
//  YWLJMapView
//
//  Created by NeiQuan on 16/7/27.
//  Copyright © 2016年 Mr-yuwei. All rights reserved.
//

#import "YWRoundAnnotationView.h"
#import "YWActionPaopaoView.h"
#define kWidth  150.f
#define kHeight 60.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0
@interface YWRoundAnnotationView(){
    
    UILabel          *_titleLable;
    UILabel          *_countLable;
    UIView           *_contentView;
    UIImageView      *_imageView;
    CAShapeLayer     *layer;
}
@end
@implementation YWRoundAnnotationView

- (instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])
    {
        [self setBounds:CGRectMake(0, 0, 150, 52)];
        [self initWithContentViews];
    }
    
    return self;
}

-(void)initWithContentViews
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(senderClick)];
    [self addGestureRecognizer:tap];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 42)];
    [view setBackgroundColor:[ UIColor  clearColor]];
    _contentView=view;
    [self addSubview:view];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 39, 10, 10)];
    [_contentView addSubview:_imageView];
    
    layer = [CAShapeLayer layer];
    layer.frame = view.frame;
    layer.path = [ UIBezierPath bezierPathWithRoundedRect:view.frame cornerRadius:20].CGPath;
    layer.fillColor = [UIColor colorWithRed:83/255.0 green:180/255.0 blue:119/255.0 alpha:1.0].CGColor;
    [view.layer addSublayer:layer];
    //layer.lineWidth = 0.3f;
    //layer.strokeColor = [ UIColor grayColor].CGColor;
    
    UILabel *lable = [[ UILabel alloc] initWithFrame:CGRectMake(10,0, 130, 20)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [ UIColor whiteColor];
    lable.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _titleLable = lable;
    [_contentView addSubview:lable];
   
    UILabel *countlable = [[ UILabel alloc] initWithFrame:CGRectMake(10,19, 130, 20)];
    countlable.textAlignment = NSTextAlignmentCenter;
    countlable.textColor = [ UIColor whiteColor];
    countlable.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    _countLable = countlable;
    [_contentView addSubview:countlable];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    return inside;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [ super setSelected:selected animated:animated];
}

- (void)setTitleText:(NSString *)titleText
{
    _titleLable.text = titleText;
}

- (void)setCountText:(NSString *)countText
{
    _countLable.text=countText;
}

- (void)setImageName:(NSString *)imageName
{
    _imageView.image = UIIMAGE(imageName);
}

- (void)setFillColor:(UIColor *)fillColor
{
    layer.fillColor = fillColor.CGColor;
}

- (void) senderClick
{
    if (_bmkAnnotationViewClick) {
        _bmkAnnotationViewClick();
    }
}

@end


@interface YWRectAnnotationView()
{
    UILabel                     *_titleLable;
    UIView                      *_contentView;
    CAShapeLayer                *shapelayer;
    
    YWActionPaopaoView          *_CalloutView;
}
@end

@implementation YWRectAnnotationView

- (instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])
    {
        [self initMakeSubViews];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    if (self.selected == selected)return;
//        if (selected)
//        {
//            if (_CalloutView == nil)
//            {
//                _CalloutView = [[YWActionPaopaoView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
//               _CalloutView.center = CGPointMake(CGRectGetWidth(_contentView. bounds) / 2.f + self.calloutOffset.x,-CGRectGetHeight(_CalloutView.bounds) / 2.f + self.calloutOffset.y);
//                UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//                btn.frame = CGRectMake(10, 10, 40, 40);
//                [btn setTitle:@"yuwei" forState:UIControlStateNormal];
//                [btn setBackgroundColor:[UIColor whiteColor]];
//                [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//
//                [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//                UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 30)];
//                name.backgroundColor = [UIColor clearColor];
//                name.textColor = [UIColor whiteColor];
//                name.text = @"Mr-yuwei";
//
//                [_CalloutView addSubview:btn];
//                [_CalloutView addSubview:name];
//
//            }
//
//            [self addSubview:_CalloutView];
//        }
//        else
//        {
//            [_CalloutView removeFromSuperview];
//        }
    [super setSelected:selected animated:animated];
}

- (void)click{
     [_CalloutView removeFromSuperview];
}

- (void)initMakeSubViews{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(senderClick)];
    [self addGestureRecognizer:tap];
    
    UIView *contentView=[[ UIView alloc] init];
    [contentView setBackgroundColor:[ UIColor clearColor]];
    _contentView=contentView;
    
    UILabel *lable=[[ UILabel alloc] init];
    lable.textColor=[ UIColor whiteColor];
    lable.font=[ UIFont systemFontOfSize:13];
    lable.textAlignment = 1;
    lable.numberOfLines = 2;
    _titleLable=lable;
    [contentView addSubview:lable];
    [self addSubview:contentView];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [_CalloutView pointInside:[self convertPoint:point toView:_CalloutView] withEvent:event];
    }
    
    return inside;
}
-(void)setTitleText:(NSString *)titleText{
    
    _titleLable.text = titleText;
    
    
    [_contentView setFrame:CGRectMake(0, 0, 100, 40)];
    [_titleLable setFrame:CGRectMake(0,3, 100, 34)];
    
    
    CGRect rect = _contentView.bounds;
    //创建Path
    CGMutablePathRef layerpath = CGPathCreateMutable();
    CGPathMoveToPoint(layerpath, NULL, 0, 0);
    CGPathAddLineToPoint(layerpath, NULL, CGRectGetMaxX(rect), 0);
    CGPathAddLineToPoint(layerpath, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    
    CGPathAddLineToPoint(layerpath, NULL, 45, CGRectGetMaxY(rect));
    CGPathAddLineToPoint(layerpath, NULL, 43, CGRectGetMaxY(rect)+6);
    CGPathAddLineToPoint(layerpath, NULL, 50, CGRectGetMaxY(rect));
    CGPathAddLineToPoint(layerpath, NULL, 0, CGRectGetMaxY(rect));
    
    shapelayer = [CAShapeLayer  layer];
    UIBezierPath * path = [ UIBezierPath  bezierPathWithCGPath:layerpath];
    shapelayer.path = path.CGPath;
    shapelayer.fillColor= [UIColor colorWithRed:83/255.0 green:180/255.0 blue:119/255.0 alpha:1.0].CGColor;
//    shapelayer.path = [UIBezierPath bezierPathWithRoundedRect:_contentView.frame cornerRadius:5].CGPath;
    shapelayer.cornerRadius = 5;
    [_contentView.layer addSublayer:shapelayer];
    [_contentView bringSubviewToFront:_titleLable];
    self.bounds=_contentView.bounds;
    
    //销毁Path
    CGPathRelease(layerpath);
    
    [ self layoutIfNeeded];
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor
{
    shapelayer.fillColor = fillColor.CGColor;
}

- (void) senderClick
{
    if (_akAnnotationViewClick) {
        _akAnnotationViewClick();
    }
}

-(void)layoutSubviews{
    
    [ super layoutSubviews];
}

@end
