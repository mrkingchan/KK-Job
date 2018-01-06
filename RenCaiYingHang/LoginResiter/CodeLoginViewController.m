//
//  CodeLoginViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "CodeLoginViewController.h"

@interface CodeLoginViewController ()<UITextFieldDelegate>
{
    CGRect origin_rect;
    UITextField * _textField;
    BOOL isAnimation;
}

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *codeView;


@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *codetf;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) NSInteger time;

@end

@implementation CodeLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stop];
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
}

/** storyboard坑爹的地方 */
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _phoneView.layer.cornerRadius = _codeView.layer.cornerRadius = _loginBtn.layer.cornerRadius = _phoneView.height/2;
    _phoneView.backgroundColor = _codeView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    _phoneTf.delegate = _codetf.delegate = self;
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

/** 进入 */
- (IBAction)insertLogin:(UIButton *)sender {
    
    if (![VerifyHelper checkMobileTel:_phoneTf.text ctl:self]) {
        return;
    }
    if ([VerifyHelper empty:_codetf.text]) {
        [UtilityHelper alertMessage:@"验证码不能为空" ctl:self];;
        return;
    }
    NSString * regID = [RYDefaults objectForKey:@"jgRegId"];
    [RYUserRequest userLoginWithParamer:@{@"loginType":@"2",@"phone":_phoneTf.text,@"dxCode":_codetf.text,@"jgRegId":regID} suceess:^(BOOL isSendSuccess) {
        [UtilityHelper insertApp];
    } failure:^(id errorCode) {
        
    }];
}

/** 获取验证码 */
- (IBAction)gainAuthCode:(UIButton *)sender {
    if (![VerifyHelper checkMobileTel:_phoneTf.text ctl:self]) {
        return;
    }
    [RYUserRequest gainAuthCodeWithParamer:@{@"phone":_phoneTf.text} suceess:^(BOOL isSendSuccess) {
        if (isSendSuccess) {
            _time = KAuthCodeSecond;
            [self countDown];
        }
    } failure:^(id errorCode) {
        
    }];
}

/** 返回密码登陆 **/
- (IBAction)returnBack:(UIButton *)sender {
   [self.navigationController popToRootViewControllerAnimated:true];
}

/** 开始读秒 */
- (void) countDown
{
    self.codeBtn.enabled = NO;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%zd秒", _time] forState:UIControlStateNormal];
    self.timer =[NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(timeAction:)
                                               userInfo:nil
                                                repeats:YES];
}

- (void)timeAction:(NSTimer *)timer
{
    --_time ;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%zd秒", _time] forState:UIControlStateNormal];
    if (_time == 0) {
        [self stop];
    }
}

/** 关掉定时器 */
- (void)stop
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    self.codeBtn.enabled = true;
    [self.codeBtn setTitle:@"验证码" forState:UIControlStateNormal];
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
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, h, kScreenWidth, kScreenHeight);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if ( isAnimation) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = origin_rect;
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
