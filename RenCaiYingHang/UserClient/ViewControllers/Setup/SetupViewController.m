//
//  SetupViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "SetupViewController.h"

#import "RemindViewController.h"
#import "SecurityCenterViewController.h"
#import "FeebBackViewController.h"
#import "GestureManageController.h"

@interface SetupViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,copy) NSArray * dataArray;

@end

static NSString * SetUPTableViewCellID = @"UITableViewCell";

@implementation SetupViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [UIFactory initTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped delegate:self];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SetUPTableViewCellID];
    }
    return _tableView;
}

- (UIView *) tableFooterView
{
    UIView * footer = [UIFactory initViewWithFrame:CGRectMake(0, 0, kScreenWidth, 80) color:nil];
    UIButton * loginOutBtn = [UIFactory initBorderButtonWithFrame:CGRectMake(50, 30, kScreenWidth - 100, 45) title:@"退出登录" textColor:[UIColor darkTextColor] font:systemOfFont(15) cornerRadius:10 bgColor:kWhiteColor borderColor:[UIColor lightGrayColor] borderWidth:0.5 tag:10 target:self action:@selector(loginOutClick:)];
    [footer addSubview:loginOutBtn];
    return footer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self configurationTableView];
}

- (void) configurationTableView
{
    self.dataArray = @[@[@"提醒设置",@"安全中心"],@[@"关于我们",@"公司动态",@"行业新闻"],@[@"意见反馈",@"手势密码"]];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [self tableFooterView];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SetUPTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.font = systemOfFont(16);
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
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
    if (section ==  self.dataArray.count - 1) {
        return 10.0;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:{
                    RemindViewController * voice = [[RemindViewController alloc] init];
                    voice.title = self.dataArray[indexPath.section][indexPath.row];
                    [self.navigationController pushViewController:voice animated:true];
                }
                    break;
                case 1:{
                    SecurityCenterViewController * security = [[SecurityCenterViewController alloc] init];
                    security.title = self.dataArray[indexPath.section][indexPath.row];
                    [self.navigationController pushViewController:security animated:true];
                }
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            CommonH5Controller * h5 = [[CommonH5Controller alloc] init];
            h5.title = self.dataArray[indexPath.section][indexPath.row];
            h5.url = @[@"https://www.baidu.com",@"https://www.so.com",@"http://www.youku.com"][indexPath.row];
            h5.progressViewColor = [UIColor redColor];
             [self.navigationController pushViewController:h5 animated:true];
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    FeebBackViewController * feed = [[FeebBackViewController alloc] init];
                    feed.title = self.dataArray[indexPath.section][indexPath.row];
                    [self.navigationController pushViewController:feed animated:true];
                }
                    break;
                case 1:
                {
                    GestureManageController * gm = [[GestureManageController alloc] init];
                    [self.navigationController showViewController:gm sender:self];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

/**
 退出登录
 */
- (void) loginOutClick:(UIButton *)sender
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
