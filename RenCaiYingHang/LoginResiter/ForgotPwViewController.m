//
//  ForgotPwViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ForgotPwViewController.h"

@interface ForgotPwViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIButton * currentBtn;
    CGRect origin_rect;
    UITextField * _textField;
    BOOL isAnimation;
}

@property (nonatomic,strong) AuthenticationModel * authModel;

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,copy) NSArray * dataArray;

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) NSInteger time;

@end

static NSString * LabelTextFieldCellID = @"LabelTextFieldCell";
static NSString * LabelTextFieldBuutonCellID = @"LabelTextFieldBuutonCell";

@implementation ForgotPwViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [UIFactory initTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped delegate:self];
        [_tableView registerNib:[UINib nibWithNibName:LabelTextFieldCellID bundle:nil] forCellReuseIdentifier:LabelTextFieldCellID];
        [_tableView registerNib:[UINib nibWithNibName:LabelTextFieldBuutonCellID bundle:nil] forCellReuseIdentifier:LabelTextFieldBuutonCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *) tableFooterView
{
    UIView * footer = [UIFactory initViewWithFrame:CGRectMake(0, 0, kScreenWidth, 80) color:nil];
    UIButton * loginOutBtn = [UIFactory initBorderButtonWithFrame:CGRectMake(50, 30, kScreenWidth - 100, 50) title:@"提交" textColor:[UIColor darkTextColor] font:systemOfFont(15) cornerRadius:5 bgColor:kWhiteColor borderColor:[UIColor lightGrayColor] borderWidth:0.5 tag:10 target:self action:@selector(buttonClick:)];
    [footer addSubview:loginOutBtn];
    return footer;
}

- (AuthenticationModel *)authModel
{
    if (!_authModel) {
        _authModel = [[AuthenticationModel alloc] init];
    }
    return _authModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登陆密码";
    [self addNotification];
    [self configurationTableView];
    isAnimation = false;
}

- (void) configurationTableView
{
    self.tableView.tableFooterView = [self tableFooterView];
    self.dataArray = @[@"手  机  号",@"",@"输入密码",@"确认密码"];
    [self.tableView reloadData];
}

/** 立即认证 **/
- (void) buttonClick:(UIButton *) sender
{
    [self closeBeyBoard];
    
    if (![VerifyHelper checkMobileTel:self.authModel.phone ctl:self]) {
        return;
    }
    
    if ([VerifyHelper empty:self.authModel.codeString]) {
        [self emptyPhoneCode];
        return;
    }
    
    if ([VerifyHelper empty:self.authModel.newsPassWord] || (self.authModel.confirmPassWord.length < 6 && self.authModel.confirmPassWord.length >12) || [VerifyHelper empty:self.authModel.confirmPassWord] || (self.authModel.confirmPassWord.length < 6 && self.authModel.confirmPassWord.length >12)) {
        [self errorPassword];
        return;
    }
    if (![self.authModel.newsPassWord isEqualToString:self.authModel.confirmPassWord]) {
        [UtilityHelper alertMessage:@"两次密码不一致" ctl:self];
        return;
    }
    
    NSDictionary * dic = @{@"phone":self.authModel.phone,@"phoneCode":self.authModel.codeString,@"newPassword":self.authModel.newsPassWord,@"confirmPassword":self.authModel.confirmPassWord};
    [RYUserRequest findLoginPwdWithParamer:dic suceess:^(BOOL isSuccess) {
        [self showAlertWithTitle:@"登陆密码重置成功" message:@"" appearanceProcess:^(EJAlertViewController * _Nonnull alertMaker) {
            alertMaker.addActionCancelTitle(@"确定");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, EJAlertViewController * _Nonnull alertSelf) {
            [self.navigationController popViewControllerAnimated:true];
        }];
    } failure:^(id errorCode) {
        
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        LabelTextFieldBuutonCell * cell = [tableView dequeueReusableCellWithIdentifier:LabelTextFieldBuutonCellID];
        [cell.codeBtn addTarget:self action:@selector(gainAuthCode) forControlEvents:UIControlEventTouchUpInside];
        currentBtn = cell.codeBtn;
        cell.textField.tag = indexPath.row;
        cell.textField.delegate = self;
        [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }else{
        LabelTextFieldCell * cell = [tableView dequeueReusableCellWithIdentifier:LabelTextFieldCellID];
        cell.titleLabel.text = self.dataArray[indexPath.row];
        cell.textField.textAlignment = NSTextAlignmentLeft;
        if (indexPath.row == 0 )
        {
            if ([VerifyHelper empty:UserInfo.userInfo.tel]) {
                cell.textField.placeholder = @"请输入手机号";
            }else{
                cell.textField.text = UserInfo.userInfo.tel;
                cell.textField.enabled = false;
                cell.textField.textAlignment = 2;
                cell.textField.textColor = [UIColor darkGrayColor];
            }
        }
        else
            cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",self.dataArray[indexPath.row]];
        
        if (indexPath.row == 2 || indexPath.row == 3 ) {
            cell.textField.secureTextEntry = true;
        }else{
            cell.textField.secureTextEntry = false;
        }
        
        cell.textField.tag = indexPath.row;
        cell.textField.delegate = self;
        [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void) gainAuthCode
{
    if (![VerifyHelper checkMobileTel:self.authModel.phone ctl:self]) {
        return;
    }
    [RYUserRequest gainAuthCodeWithParamer:@{@"phone":self.authModel.phone} suceess:^(BOOL isSendSuccess) {
        [XYQProgressHUD showSuccess:@"发送成功"];
        _time = KAuthCodeSecond;
        [self countDown];
    } failure:^(id errorCode) {
        
    }];
}

/** 开始读秒 */
- (void) countDown
{
    currentBtn.enabled = NO;
    [currentBtn setTitle:[NSString stringWithFormat:@"%zd秒", _time] forState:UIControlStateNormal];
    self.timer =[NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(timeAction:)
                                               userInfo:nil
                                                repeats:YES];
}

- (void)timeAction:(NSTimer *)timer
{
    --_time ;
    
    [currentBtn setTitle:[NSString stringWithFormat:@"%zd秒", _time] forState:UIControlStateNormal];
    
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
    currentBtn.enabled = true;
    [currentBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
}

#pragma mark  -键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _textField = textField;
    return true;
}

/** textField的值 **/
- (void) textFieldDidChange:(UITextField *) textField
{
    switch (textField.tag) {
        case 0:
            self.authModel.phone = textField.text;
            break;
        case 1:
            self.authModel.codeString = textField.text;
            break;
        case 2:
            self.authModel.newsPassWord = textField.text;
            break;
        case 3:
            self.authModel.confirmPassWord = textField.text;
            break;
        default:
            break;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    origin_rect = CGRectMake(0, 0, kScreenWidth , kScreenHeight);
    
    CGFloat h = kScreenHeight - (_textField.tag+1) * 50 - height - KNavBarHeight ;
    
    if (h < 0) {
        
        isAnimation  = true;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, h, kScreenWidth, kScreenHeight);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (isAnimation) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = origin_rect;
            origin_rect = CGRectZero;
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stop];
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
