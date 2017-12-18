//
//  RyAnnotationView.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <MapKit/MapKit.h>

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "RyCalloutAnimation.h"

typedef void (^ReturnMark)(NSString *mark);

@interface RyAnnotationView : MKAnnotationView

@property (nonatomic ,strong) RyCalloutAnnotation  * ryAnnotation;

@property(copy,nonatomic)ReturnMark markAble;

#pragma mark 从缓存取出标注视图
+(instancetype)calloutViewWithMapView:(MKMapView *)mapView;


- (void)getReturnMark:(ReturnMark)mark;

@end
