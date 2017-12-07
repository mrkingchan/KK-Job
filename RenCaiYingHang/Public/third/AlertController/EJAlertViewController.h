//
//  EJAlertViewController.h
//  ehome
//
//  Created by xfej on 17/3/2.
//  Copyright © 2017年 消费e家. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EJAlertViewController;



typedef void (^AlertActionBlock)(NSInteger buttonIndex, UIAlertAction *action, EJAlertViewController * alertSelf);

typedef void (^AlertActionsConfig)(AlertActionBlock actionBlock);



typedef EJAlertViewController * (^AlertActionTitle)(NSString *title);


NS_CLASS_AVAILABLE_IOS(8_0) @interface EJAlertViewController : UIAlertController

/**
 * Actions设置
 */
- (AlertActionsConfig)alertActionsConfig;


/**
 * 默认
 */
- (AlertActionTitle)addActionDefaultTitle;

/**
 * 取消
 */
- (AlertActionTitle)addActionCancelTitle;

/**
 * 警告
 */
- (AlertActionTitle)addActionDestructiveTitle;


@end
