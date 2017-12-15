//
//  GestureSetController.h
//  Test
//
//  Created by xfej on 16/11/3.
//  Copyright © 2016年  消费e家. All rights reserved.
//

#import "RYViewController.h"

typedef enum{
    GestureViewControllerTypeSetting = 1,
    GestureViewControllerTypeLogin
}GestureViewControllerType;

typedef enum{
    buttonTagReset = 1,
    buttonTagManager,
    buttonTagForget
    
}buttonTag;

@interface GestureSetController : RYViewController

/**
 *  控制器来源类型
 */
@property (nonatomic, assign) GestureViewControllerType type;

@end
