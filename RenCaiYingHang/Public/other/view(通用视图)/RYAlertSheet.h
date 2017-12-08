//
//  RYAlertSheet.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/8.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYAlertSheet : UIView

- (RYAlertSheet *) initWithButtons:(NSArray*)allButtons;

@property (nonatomic,copy) void(^ryAlertSheetCall)(NSInteger index);

- (void) show;

@end
