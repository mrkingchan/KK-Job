//
//  GestureVerifyViewController.m
//  Test
//
//  Created by xfej on 16/11/3.
//  Copyright © 2016年 消费e家. All rights reserved.
//

#import "GestureVerifyViewController.h"
#import "PCCircleViewConst.h"
#import "PCCircleView.h"
#import "PCLockLabel.h"
#import "GestureSetController.h"

@interface GestureVerifyViewController ()<CircleViewDelegate>

/**
 *  文字提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  错误操作次数
 */
@property (nonatomic,assign) NSInteger errorCount;

@end

@implementation GestureVerifyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _errorCount = 0;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:CircleViewBackgroundColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"验证手势解锁";
    
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    [lockView setType:CircleViewTypeVerify];
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 30);
    [msgLabel showNormalMsg:gestureTextOldGesture];
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
}

#pragma mark - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
#pragma mark 如果错误次数过多将不可操作 记录错误操作次数 错误3次  提示不可操作 ,关闭操作系统
    if (type == CircleViewTypeVerify)
    {
        if (equal)
        {
            NSLog(@"验证成功");
            
            if (self.isToSetNewGesture)
            {
                GestureSetController *gestureVc = [[GestureSetController alloc] init];
                [gestureVc setType:GestureViewControllerTypeSetting];
                [self.navigationController pushViewController:gestureVc animated:YES];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"close" forKey:@"setOn"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } else
            {
            NSLog(@"密码错误！");
            _errorCount++;
            if (_errorCount >= 3)
            {
                view.userInteractionEnabled = NO;
                [self.msgLabel showWarnMsgAndShake:@"错误次数过多,不能再次操作手势"];
            }
            else
            {
                [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
            }
           }
    }
}
@end
