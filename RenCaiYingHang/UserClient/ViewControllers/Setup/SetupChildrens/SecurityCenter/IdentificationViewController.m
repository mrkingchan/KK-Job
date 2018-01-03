//
//  IdentificationViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/8.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "IdentificationViewController.h"

@interface IdentificationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,copy) NSArray * dataArray;

@property (nonatomic,strong) AuthenticationModel * authModel;

@end

static NSString * CurrentTableViewCellID = @"LabelTextFieldCell";

@implementation IdentificationViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [UIFactory initTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped delegate:self];
        [_tableView registerNib:[UINib nibWithNibName:CurrentTableViewCellID bundle:nil] forCellReuseIdentifier:CurrentTableViewCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *) tableFooterView
{
    UIView * footer = [UIFactory initViewWithFrame:CGRectMake(0, 0, kScreenWidth, 80) color:nil];
    UIButton * loginOutBtn = [UIFactory initBorderButtonWithFrame:CGRectMake(50, 30, kScreenWidth - 100, 50) title:@"立即认证" textColor:[UIColor darkTextColor] font:systemOfFont(15) cornerRadius:5 bgColor:kWhiteColor borderColor:[UIColor lightGrayColor] borderWidth:0.5 tag:10 target:self action:@selector(buttonClick:)];
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
    self.title = @"身份证认证";
    [self configurationTableView];
}

- (void) configurationTableView
{
    self.tableView.tableFooterView = [self tableFooterView];
    self.dataArray = @[@"姓名",@"身份证"];
    [self.tableView reloadData];
}

/** 立即认证 **/
- (void) buttonClick:(UIButton *) sender
{
    if ([VerifyHelper empty:self.authModel.realName]) {
        [self alertMessageWithViewController:self message:@"用户名不能为空"];
        return;
    }
    if (![VerifyHelper validateIDCardNumber:self.authModel.idcardNum]) {
        [self alertMessageWithViewController:self message:@"身份证不正确"];
        return;
    }
    NSDictionary * dic = @{@"realName":self.authModel.realName,@"idcardNum":self.authModel.idcardNum};
    [RYUserRequest idcardAuthenticationWithParamer:dic suceess:^(BOOL isSuccess) {
        [self.navigationController popViewControllerAnimated:true];
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
    LabelTextFieldCell * cell = [tableView dequeueReusableCellWithIdentifier:CurrentTableViewCellID];
    cell.titleLabel.text = self.dataArray[indexPath.row];
    cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",self.dataArray[indexPath.row]];
    cell.textField.tag = indexPath.row;
    cell.textField.delegate = self;
    [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return cell;
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

/** textField的值 **/
- (void) textFieldDidChange:(UITextField *) textField
{
    switch (textField.tag) {
        case 0:
            self.authModel.realName = textField.text;
            break;
        case 1:
            self.authModel.idcardNum = textField.text;
            break;
        default:
            break;
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
