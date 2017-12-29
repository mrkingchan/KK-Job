//
//  RYShareView.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/29.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RYShareViewType) {
    ShareUser = 1,
    ShareJob,
    ShareCompany
};

@interface RYShareView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(RYShareViewType) type;

@property (nonatomic,strong) UIImage * image;

@property (nonatomic,copy) void(^shareCallBack)(NSInteger index);

@end
