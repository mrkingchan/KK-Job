//
//  UIViewController+AlertController.h
//  ehome
//
//  Created by xfej on 17/3/2.
//  Copyright © 2017年 消费e家. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EJAlertViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 SVAlertViewController: alert构造块
 */
typedef void(^AlertAppearanceProcess)(EJAlertViewController * alertMaker);

/**
 * AlertController: alert按钮执行回调
 */
typedef void (^AlertActionBlock)(NSInteger buttonIndex, UIAlertAction *action, EJAlertViewController * alertSelf);



@interface UIViewController (AlertController)


/**
 * alert方式
 */
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message appearanceProcess:(AlertAppearanceProcess)appearanceProcess actionsBlock:(AlertActionBlock)actionBlock NS_AVAILABLE_IOS(8.0);

/**
 * sheet方式
 */
- (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
               appearanceProcess:(AlertAppearanceProcess)appearanceProcess
                    actionsBlock:(AlertActionBlock)actionBlock NS_AVAILABLE_IOS(8_0);

//@interface UIViewController (AlertController)

@end

NS_ASSUME_NONNULL_END
