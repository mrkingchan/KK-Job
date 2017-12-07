//
//  OSGuideViewController.h
//  OSNewFrame
//
//  Created by Macx on 2017/11/29.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OSGuideSelectDelegate <NSObject>

- (void) clickEnter;

@end

@interface OSGuideViewController : UIViewController

@property (nonatomic, strong) UIButton *btnEnter;

// 初始化引导页
- (void)guidePageControllerWithImages:(NSArray *)images;

+ (BOOL)isShow;

@property (nonatomic, assign) id<OSGuideSelectDelegate> delegate;

@end
