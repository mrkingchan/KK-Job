//
//  LoginViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    CGRect origin_rect;
    UITextField * _textField;
}

@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *pwView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *pwTf;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:animated];
    // 去掉返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
}

/** storyboard坑爹的地方 */
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _phoneView.layer.cornerRadius = _pwView.layer.cornerRadius = _loginBtn.layer.cornerRadius =  _phoneView.height/2;
    _phoneTf.delegate = _pwTf.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:UIIMAGE(@"bg")]];
    [self addNotification];
}

/** 登陆账号 */
- (IBAction)loginAccount:(UIButton *)sender {
    if (![VerifyHelper checkMobileTel:_phoneTf.text ctl:self]) {
        return;
    }
    if ([VerifyHelper empty:_pwTf.text] &&[_pwTf.text length] <8) {
        [self errorPassword];
        return;
    }
    
    [RYUserRequest userLoginWithParamer:@{@"loginType":@"1",@"phone":_phoneTf.text,@"password":_pwTf.text} suceess:^(BOOL isSendSuccess) {
        [UtilityHelper insertApp];
    } failure:^(id errorCode) {
        
    }];
}

#pragma mark  -键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _textField = textField;
    return true;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    origin_rect = CGRectMake(0, 0, kScreenWidth , kScreenHeight);
    
    CGFloat h = kScreenHeight - _textField.superview.bottom - height  ;
    
    if (h < 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, h, kScreenWidth, kScreenHeight);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = origin_rect;
        origin_rect = CGRectZero;
    }];
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
