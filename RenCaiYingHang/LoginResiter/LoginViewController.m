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
    BOOL isAnimation;
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
}

/** storyboard坑爹的地方 */
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _phoneView.layer.cornerRadius = _pwView.layer.cornerRadius = _loginBtn.layer.cornerRadius =  _phoneView.height/2;
    _phoneView.backgroundColor = _pwView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    _phoneTf.delegate = _pwTf.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:UIIMAGE(@"bg")]];
    [self addNotification];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeBeyBoard)];
    [self.view addGestureRecognizer:tap];
    isAnimation = false;
}

/** 登陆账号 */
- (IBAction)loginAccount:(UIButton *)sender {
    
    [self closeBeyBoard];
    
    if (![VerifyHelper checkMobileTel:_phoneTf.text ctl:self]) {
        return;
    }
    if ([VerifyHelper empty:_pwTf.text] || [_pwTf.text length] < 8) {
        [UtilityHelper alertMessage:@"密码不正确" ctl:self];
        return;
    }
    NSString * regID = [RYDefaults objectForKey:@"jgRegId"];
    
    NSDictionary * dic = @{@"loginType":@"1",@"phone":_phoneTf.text,@"password":_pwTf.text};
    /** 推送注册id不为空 */
    if (![VerifyHelper empty:regID])
    {
        dic = @{@"loginType":@"1",@"phone":_phoneTf.text,@"password":_pwTf.text,@"jgRegId":regID};
    }
    [XYQProgressHUD showMessage:@"登陆中...."];
    [RYUserRequest userLoginWithParamer:dic suceess:^(BOOL isSendSuccess) {
        [XYQProgressHUD hideHUD];
        [UtilityHelper insertApp];
    } failure:^(id errorCode) {
        
    }];
}

- (void)closeBeyBoard
{
    for (id class in self.view.subviews)
    {
        if ([class isKindOfClass:[UITextView class]] || [class isKindOfClass:[UITextField class]]) {
            [class endEditing:YES];
        }
    }
    [self.view endEditing:YES];
}

#pragma mark  -键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _textField = textField;
    return true;
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
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    origin_rect = CGRectMake(0, 0, kScreenWidth , kScreenHeight);
    
    CGFloat h = kScreenHeight - _textField.superview.bottom - height  ;
    
    if (h < 0) {
        
        isAnimation = true;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, h, kScreenWidth, kScreenHeight);
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (isAnimation) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = origin_rect;
            [self.view layoutIfNeeded];
            origin_rect = CGRectZero;
        }];
    }
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
