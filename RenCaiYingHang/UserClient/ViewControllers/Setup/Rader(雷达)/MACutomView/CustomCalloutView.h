//
//  CustomCalloutView.h
//  RenCaiYingHang
//
//  Created by Macx on 2018/1/5.
//  Copyright © 2018年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCalloutView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,copy) void(^annotationClickCallBack)(void);

@end
