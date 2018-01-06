//
//  RemindViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/8.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RemindViewController.h"

#import "LabelSwitchCell.h"

#import "RYAlertSheet.h"

@interface RemindViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,copy) NSArray * dataArray;

@property (nonatomic,strong) NSMutableArray *typeArr;
@property (nonatomic,copy) NSArray * messageArray;

@end

static NSString * LabelSwitchCellID = @"LabelSwitchCell";
static NSString * TableViewCellID = @"UITableViewCell";

@implementation RemindViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [UIFactory initTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped delegate:self];
        [_tableView registerNib:[UINib nibWithNibName:LabelSwitchCellID bundle:nil] forCellReuseIdentifier:LabelSwitchCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configurationTableView];
}

- (void) configurationTableView
{
    self.dataArray = @[@[@"声音与震动"],@[@"有人对我的资料感兴趣",@"有人查看了我的资料",@"有人新发布了我期望的职位"]];//@[@"重要消息未接收时短信提醒"]
    //self.typeArr = @[@"0",@"0",@"0"].mutableCopy;
    //self.messageArray = @[@"即时提醒",@"每日提醒",@"每周提醒",@"每月提醒"];
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableViewCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = cell.detailTextLabel.font = systemOfFont(16);
        cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
        cell.detailTextLabel.text = @"即时提醒";//self.messageArray[[self.typeArr[indexPath.row] integerValue]];
        return cell;
    }else{
        LabelSwitchCell * cell = [tableView dequeueReusableCellWithIdentifier:LabelSwitchCellID];
        cell.titleLabel.text = self.dataArray[indexPath.section][indexPath.row];
        [cell.switchHandle addTarget:self action:@selector(gestureUnLockSwitchChanged:) forControlEvents:UIControlEventValueChanged];
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
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LabelViewCell * cell = [[NSBundle mainBundle] loadNibNamed:@"LabelViewCell" owner:nil options:nil].lastObject;
    cell.frame = CGRectMake(0, 0, kScreenWidth, 50);
    cell.textLabel.text = @[@"提醒设置",@"通知提醒",@"短信设置"][section];
    cell.textLabel.font = systemOfFont(16);
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 1) {
//        RYAlertSheet * sheet = [[RYAlertSheet alloc] initWithButtons:self.messageArray];
//        [sheet show];
//
//        sheet.ryAlertSheetCall = ^(NSInteger index) {
//            /** 先网路处理 **/
//            [self.typeArr replaceObjectAtIndex:indexPath.row withObject:@(index)];
//            [self.tableView reloadData];
//        };
//    }
}

- (void)gestureUnLockSwitchChanged:(UISwitch *)sender
{
    sender.on = !sender.on;
    NSInteger isSend = sender.on == true ? 1: 2;
    NSDictionary * dic = @{@"token":UserInfo.userInfo.token,@"jgWhetherSend":@(isSend)};
    NSDictionary * encry = [UtilityHelper encryptParmar:dic];
    [NetWorkHelper getWithURLString:[NSString stringWithFormat:@"%@securityCenter/appWhetherJgSend",KBaseURL] parameters:encry success:^(NSDictionary *data) {
        
    } failure:^(NSError *error) {
        
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
