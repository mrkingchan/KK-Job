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

/** 键盘关闭 */
- (void)closeBeyBoard;

/** 键盘通知 */
- (void) addNotification;

/** 提示信息类 **/
- (void) emptyPhoneCode;

- (void) errorPassword;

@end
