//
//  UIViewController+AlertController.m
//  ehome
//
//  Created by xfej on 17/3/2.
//  Copyright © 2017年 消费e家. All rights reserved.
//

#import "UIViewController+AlertController.h"

@implementation UIViewController (AlertController)

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message appearanceProcess:(AlertAppearanceProcess)appearanceProcess actionsBlock:(AlertActionBlock)actionBlock
{
    [self showAlertWithPreferredStyle:UIAlertControllerStyleAlert title:title message:message appearanceProcess:appearanceProcess actionsBlock:actionBlock];
}

- (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
               appearanceProcess:(AlertAppearanceProcess)appearanceProcess
                    actionsBlock:(AlertActionBlock)actionBlock NS_AVAILABLE_IOS(8_0)
{
    [self showAlertWithPreferredStyle:UIAlertControllerStyleActionSheet title:title message:message appearanceProcess:appearanceProcess actionsBlock:actionBlock];
}


- (void)showAlertWithPreferredStyle:(UIAlertControllerStyle)preferredStyle title:(NSString *)title message:(NSString *)message appearanceProcess:(AlertAppearanceProcess)appearanceProcess actionsBlock:(AlertActionBlock)actionBlock{
    
    if (appearanceProcess)
    {
        EJAlertViewController * alertMaker = [EJAlertViewController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
        
        if (!alertMaker) {
            return ;
        }
        
        appearanceProcess(alertMaker);
        
        alertMaker.alertActionsConfig(actionBlock);
        
        [self presentViewController:alertMaker animated:YES completion:nil];
    }

}

@end
