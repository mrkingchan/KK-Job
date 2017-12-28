//
//  UIImageView+RotateImgV.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/28.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "UIImageView+RotateImgV.h"

@implementation UIImageView (RotateImgV)

- (void)rotate360DegreeWithImageView:(BOOL) isRight {
    CABasicAnimation * rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    if (isRight) {
       rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    }else{
      rotationAnimation.toValue = [NSNumber numberWithFloat: - M_PI * 2.0 ];
    }
    
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100000;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopRotate {
    [self.layer removeAllAnimations];
}

@end
