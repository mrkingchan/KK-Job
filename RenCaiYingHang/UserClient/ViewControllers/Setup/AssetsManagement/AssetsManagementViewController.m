//
//  AssetsManagementViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/11.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "AssetsManagementViewController.h"

#import "RechargeViewController.h"

@interface AssetsManagementViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,copy) NSArray * dataArray;

@end

static NSString * UITableViewCellID = @"UITableViewCell";

@implementation AssetsManagementViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [UIFactory initTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped delegate:self];
        _tableView.backgroundColor = kWhiteColor;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *) headerView
{
    CGFloat h = 175*kScreenHeight/667;
    UIView * header = [UIFactory initViewWithFrame:CGRectMake(0, 0, kScreenWidth, h) color:Color235];
    
    UILabel * label = [UIFactory initLableWithFrame:CGRectMake(20, 50*h/175, kScreenWidth - 40, 30 *h/175) title:@"账户余额(元)" textColor:[UIColor darkTextColor] font:systemOfFont(15) textAlignment:0];
    [header addSubview:label];
    
    UILabel * money = [UIFactory initLableWithFrame:CGRectMake(20, label.bottom + 10, kScreenWidth - 40, 60 *h/175) title:@"0.00" textColor:[UIColor darkTextColor] font:systemOfFont(36) textAlignment:0];
    [header addSubview:money];
    
    return header;
}

- (UIView * )footerView
{
    UIView * footer = [UIFactory initViewWithFrame:CGRectMake(0, 0, kScreenWidth, 80) color:nil];
    
    NSArray * titleArr = @[@"充值",@"提现"];
    CGFloat w = (kScreenWidth - 2 * 20 - 10) /2;
    for (int i = 0; i < 2; i++) {
        UIButton * button = [UIFactory initBorderButtonWithFrame:CGRectMake(20 + w*i + 10 *i, 40, w, 40) title:titleArr[i] textColor:[UIColor darkTextColor] font:systemOfFont(16) cornerRadius:5 bgColor:nil borderColor:Color235 borderWidth:0.5 tag:1 target:self action:@selector(buttonClick:)];
        button.tag = i;
        [footer addSubview:button];
    }
    
    return footer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"资产管理";
    [self configurationTableView];
}

- (void) configurationTableView
{
    self.tableView.tableHeaderView = [self headerView];
    self.tableView.tableFooterView = [self footerView];
    self.dataArray = @[@"可用金额",@"冻结金额"];
    [self.tableView reloadData];
}

/** 充值,提现 */
- (void) buttonClick:(UIButton *) sender
{
    if (sender.tag == 0) {
      //充值
        RechargeViewController * recharege = [[RechargeViewController alloc] init];
        [self.navigationController showViewController:recharege sender:self];
    }else{
      //提现
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UITableViewCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.detailTextLabel.text = @"0.00元";
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.00;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIFactory initViewWithFrame:CGRectMake(0, 0, kScreenWidth, 10) color:Color235];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
