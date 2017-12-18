//
//  RyAnnotationView.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RyAnnotationView.h"

#define kSpacing 5
#define kDetailFontSize 12
#define kViewOffset 80

@interface RyAnnotationView()
{
    UIButton *_iconView;
    UILabel *_detailLabel;
    UILabel *_distance;
}

@end

@implementation RyAnnotationView

- (instancetype)init{
    if(self=[super init]){
        [self layoutUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI{
    //背景
    //    _backgroundView=[[UIView alloc]init];
    //    _backgroundView.backgroundColor = [UIColor whiteColor];
    //左侧添加图标
    _iconView=[[UIButton alloc]init];
    
    //上方详情
    _detailLabel=[[UILabel alloc]init];
    _detailLabel.lineBreakMode=NSLineBreakByWordWrapping;
    //[_text sizeToFit];
    _detailLabel.font=[UIFont systemFontOfSize:kDetailFontSize];
    
    _distance =[[UILabel alloc]init];
    _distance.lineBreakMode=NSLineBreakByWordWrapping;
    //[_text sizeToFit];
    _distance.font=[UIFont systemFontOfSize:kDetailFontSize];
    
    //    [self addSubview:_backgroundView];
    [self addSubview:_iconView];
    [self addSubview:_detailLabel];
    [self addSubview:_distance];
}

+ (instancetype)calloutViewWithMapView:(MKMapView *)mapView{
    static NSString * calloutKey = @"calloutKey1";
    RyAnnotationView * calloutView = (RyAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:calloutKey];
    if (!calloutView) {
        calloutView = [[RyAnnotationView alloc]init];
    }
    return calloutView;
}

#pragma mark 当给大头针视图设置大头针模型时可以在此处根据模型设置视图内容
- (void)setRyAnnotation:(RyCalloutAnnotation *)ryAnnotation{
    [super setAnnotation:ryAnnotation];
    //根据模型调整布局
    [_iconView setImage:ryAnnotation.icon forState:UIControlStateNormal];
    _iconView.frame = CGRectMake(kSpacing, kSpacing, ryAnnotation.icon.size.width, ryAnnotation.icon.size.height);
    [_iconView addTarget:self action:@selector(tapWithNew) forControlEvents:UIControlEventTouchUpInside];
    
    
    _detailLabel.text= ryAnnotation.detail;
    float detailWidth = 150.0;
    CGSize detailSize= [ryAnnotation.detail boundingRectWithSize:CGSizeMake(detailWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kDetailFontSize]} context:nil].size;
    
    float detailX=CGRectGetMaxX(_iconView.frame)+kSpacing;
    _detailLabel.frame=CGRectMake(detailX, kSpacing, detailSize.width, detailSize.height);
    
    _distance.text = ryAnnotation.distance;
    _distance.frame = CGRectMake(detailX, CGRectGetMaxY(_detailLabel.frame)+kSpacing, detailWidth, 20);
    
    float backgroundWidth=CGRectGetMaxX(_detailLabel.frame)+kSpacing;
    float backgroundHeight=_iconView.frame.size.height+2*kSpacing;
    //    _backgroundView.frame=CGRectMake(0, 0, backgroundWidth, backgroundHeight);
    self.bounds=CGRectMake(0, 0, backgroundWidth, backgroundHeight+kViewOffset);
}

- (void)tapWithNew{
    self.markAble(@"标记");
}

- (void)getReturnMark:(ReturnMark)mark{
    self.markAble = mark;
}

@end
