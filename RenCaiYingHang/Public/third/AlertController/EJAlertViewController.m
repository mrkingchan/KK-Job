//
//  EJAlertViewController.m
//  ehome
//
//  Created by xfej on 17/3/2.
//  Copyright © 2017年 消费e家. All rights reserved.
//

#import "EJAlertViewController.h"

#pragma mark - AlertActionModel
@interface AlertActionModel : NSObject

@property (nonatomic, copy) NSString * title;

@property (nonatomic, assign) UIAlertActionStyle style;

@end

@implementation AlertActionModel

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"";
        self.style = UIAlertActionStyleDefault;
    }
    return self;
}

@end

@interface EJAlertViewController ()

@property (nonatomic, strong) NSMutableArray * alertActionArray;

@end

@implementation EJAlertViewController

- (NSMutableArray *)alertActionArray
{
    if (_alertActionArray == nil) {
        _alertActionArray = [NSMutableArray array];
    }
    return _alertActionArray;
}

- (AlertActionsConfig)alertActionsConfig{
    
    
    void (^AlertActionsConfig)(AlertActionBlock actionBlock) = ^(AlertActionBlock actionBlock) {
        
        if (self.alertActionArray.count > 0)
        {
            //创建action
            __weak typeof(self)weakSelf = self;
            [self.alertActionArray enumerateObjectsUsingBlock:^(AlertActionModel *actionModel, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionModel.title style:actionModel.style handler:^(UIAlertAction * _Nonnull action) {
                    
                    __strong typeof(weakSelf)strongSelf = weakSelf;
                    
                    if (actionBlock) {
                        actionBlock(idx, action, strongSelf);
                    }
                }];
                
                [self addAction:alertAction];
            }];
        }
        
    };
    return AlertActionsConfig;
    //    return ^(AlertActionBlock actionBlock) {
    //
    //    };
}

- (AlertActionTitle)addActionDefaultTitle
{
    return ^(NSString *title){
        AlertActionModel * actionModel = [[AlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDefault;
        [self.alertActionArray addObject:actionModel];
        
        return self;
    };
}

- (AlertActionTitle)addActionCancelTitle
{
    return ^(NSString *title){
        
        AlertActionModel * actionModel = [[AlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDefault;
        [self.alertActionArray addObject:actionModel];
        
        return self;
    };
}

- (AlertActionTitle)addActionDestructiveTitle
{
    EJAlertViewController * (^AlertActionTitle)(NSString *title) = ^(NSString *title){
        
        AlertActionModel * actionModel = [[AlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDefault;
        [self.alertActionArray addObject:actionModel];
        
        return self;
    };
    return AlertActionTitle;
}

@end
