//
//  ForgotPwViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ForgotPwViewController.h"

@interface ForgotPwViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton * currentBtn;
}

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,copy) NSArray * dataArray;

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) NSInteger time;

@end

static NSString * LabelTextFieldCellID = @"LabelTextFieldCell";
static NSString * LabelTextFieldBuutonCellID = @"LabelTextFieldBuutonCell";

@implementation ForgotPwViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [UIFactory initTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KNavBarHeight) style:UITableViewStyleGrouped delegate:self];
        [_tableView registerNib:[UINib nibWithNibName:LabelTextFieldCellID bundle:nil] forCellReuseIdentifier:LabelTextFieldCellID];
        [_tableView registerNib:[UINib nibWithNibName:LabelTextFieldBuutonCellID bundle:nil] forCellReuseIdentifier:LabelTextFieldBuutonCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *) tableFooterView
{
    UIView * footer = [UIFactory initViewWithFrame:CGRectMake(0, 0, kScreenWidth, 80) color:nil];
    UIButton * loginOutBtn = [UIFactory initBorderButtonWithFrame:CGRectMake(50, 30, kScreenWidth - 100, 45) title:@"提交" textColor:[UIColor darkTextColor] font:systemOfFont(15) cornerRadius:10 bgColor:kWhiteColor borderColor:[UIColor lightGrayColor] borderWidth:0.5 tag:10 target:self action:@selector(buttonClick:)];
    [footer addSubview:loginOutBtn];
    return footer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登陆密码";
    
    [self configurationTableView];
}

- (void) configurationTableView
{
    self.tableView.tableFooterView = [self tableFooterView];
    self.dataArray = @[@"手机号",@"",@"输入密码",@"确认密码"];
    [self.tableView reloadData];
}

/** 立即认证 **/
- (void) buttonClick:(UIButton *) sender
{
    
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
        [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }else{
        LabelTextFieldCell * cell = [tableView dequeueReusableCellWithIdentifier:LabelTextFieldCellID];
        cell.titleLabel.text = self.dataArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.textField.text = @"18681446361";
            cell.textField.textColor = [UIColor lightGrayColor];
            cell.textField.enabled = false;
        }else{
            cell.textField.textAlignment = 0;
            cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",self.dataArray[indexPath.row]];
        }
        cell.textField.tag = indexPath.row;
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
    _time = KAuthCodeSecond;
    [self countDown];
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

/** textField的值 **/
- (void) textFieldDidChange:(UITextField *) textField
{
    
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
