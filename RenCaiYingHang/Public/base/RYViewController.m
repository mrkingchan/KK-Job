//
//  RYViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYViewController.h"

#import "LoginViewController.h"
#import "ResiterViewController.h"
#import "ForgotPwViewController.h"
#import "CodeLoginViewController.h"

@interface RYViewController ()

@end

@implementation RYViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /** 非登陆注册需要进行登陆认证 */
    if ([self isKindOfClass:[LoginViewController class]] || [self isKindOfClass:[ResiterViewController class]] || ([self isKindOfClass:[ForgotPwViewController class]] && self.navigationController.viewControllers.count==2) || [self isKindOfClass:[CodeLoginViewController class]]) {
        return;
    }
   // [self loginAuth];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doSomething:) name:@"UserJPushNotification" object:nil];
}

- (void) doSomething:(NSNotification *)notification
{
    //NSDictionary *userInfo = [notification userInfo];
    NSString * notificationName = [notification name];
    if ([notificationName isEqualToString:@"UserJPushNotification"] && [UserInfo.userInfo.reCode isEqualToString:@"X2222"]) {
        RYTabBarController * tab = (RYTabBarController *)[UIFactory getKeyWindow].rootViewController;
        tab.selectedIndex = 2;
        // self.tabBarController.selectedIndex =  2;
    }
}

/** 登陆认证,此方法已失效 */
- (void) loginAuth
{
    NSDictionary * a = @{@"token":UserInfo.userInfo.token,@"pkey":UserInfo.userInfo.pkey};
    [RYUserRequest loginAuthWithParamer:a suceess:^(BOOL isSendSuccess) {
        if (!isSendSuccess) {
            UIViewController * loginCtl = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
            [UIFactory getKeyWindow].rootViewController = [[RYNavigationController alloc] initWithRootViewController:loginCtl];
        }else{
            [self alertMessageWithViewController:self message:[NSString stringWithFormat:@"token传值成功-%@",UserInfo.userInfo.token]];
        }
    } failure:^(id errorCode) {
        
    }];
}

#pragma mark 键盘
- (UIView *)inputAccessoryView
{
    CGRect accessFrame = CGRectMake(0, 0, kScreenWidth, 44);
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:accessFrame];
    UIButton *closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60, 4, 40, 40)];
    [closeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [closeBtn addTarget:self action:@selector(closeBeyBoard) forControlEvents:UIControlEventTouchDown];
    [toolbar addSubview:closeBtn];
    return toolbar;
}

- (void)closeBeyBoard
{
    for (id view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITextView class]] || [view isKindOfClass:[UITextField class]]) {
            [view endEditing:YES];
        }
    }
    [self.view endEditing:YES];
}

//当有一个或多个手指触摸事件在当前视图或window窗体中响应
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    int x = point.x;
    int y = point.y;
    NSLog(@"touch (x, y) is (%d, %d)", x, y);
    [self closeBeyBoard];
}

/** 提示框 */
- (void) alertMessageWithViewController:(UIViewController *)viewCtl message:(NSString *)message
{
    [viewCtl showAlertWithTitle:message message:@"" appearanceProcess:^(EJAlertViewController * _Nonnull alertMaker) {
       alertMaker.addActionCancelTitle(@"确定");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, EJAlertViewController * _Nonnull alertSelf) {
        
    }];
}

/** 键盘通知 **/
- (void) addNotification
{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [notification addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
}


/** 提示信息类 **/
- (void) emptyPhoneCode
{
    [self alertMessageWithViewController:self message:@"验证码不能为空"];
}

- (void) errorPassword
{
    [self alertMessageWithViewController:self message:@"密码不正确"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
