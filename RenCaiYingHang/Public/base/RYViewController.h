//
//  RYViewController.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYViewController : UIViewController

/** 提示框 */
- (void) alertMessageWithViewController:(UIViewController *)viewCtl message:(NSString *)message;

- (void)closeBeyBoard;

@end
