//
//  GestureManageController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/15.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "GestureManageController.h"

#import "GestureSetController.h"
#import "GestureVerifyViewController.h"
#import "PCCircleViewConst.h"

#import "LabelSwitchCell.h"

@interface GestureManageController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,copy) NSArray * dataArray;

@end

static NSString * LabelSwitchCellID = @"LabelSwitchCell";
static NSString * TableViewCellID = @"UITableViewCell";

@implementation GestureManageController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [UIFactory initTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped delegate:self];
        [_tableView registerNib:[UINib nibWithNibName:LabelSwitchCellID bundle:nil] forCellReuseIdentifier:LabelSwitchCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configurationTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"手势管理";
}

- (void) configurationTableView
{
    self.dataArray = @[@[@"手势解锁"],@[@"修改手势密码",@"忘记手势密码"]];
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"setOn"] isEqualToString:@"open"] ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"setOn"] isEqualToString:@"open"]) {
        return section == 0 ? 1 : 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LabelSwitchCell * cell = [tableView dequeueReusableCellWithIdentifier:LabelSwitchCellID];
        cell.titleLabel.text = self.dataArray[indexPath.section][indexPath.row];
        cell.switchHandle.on = [[[NSUserDefaults standardUserDefaults] objectForKey:@"setOn"] isEqualToString:@"open"] ? true : false;
        [cell.switchHandle addTarget:self action:@selector(gestureUnLockSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableViewCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = systemOfFont(16);
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        //跳转到修改手势界面
        GestureVerifyViewController *gestureVc = [[GestureVerifyViewController alloc] init];
        gestureVc.isToSetNewGesture = YES;
        [self.navigationController pushViewController:gestureVc animated:YES];
    }
    else if (indexPath.section == 1)
    {
        //忘记密码 清空所有数据
        [PCCircleViewConst saveGesture:nil Key:gestureFinalSaveKey];
        [[NSUserDefaults standardUserDefaults] setObject:@"close" forKey:@"setOn"];
        [self alertMessageWithViewController:self message:@"手势关闭成功"];
        [self.tableView reloadData];
    }
}

/** 开关事件 **/
//开关
- (void)gestureUnLockSwitchChanged:(UISwitch *)sender
{
    if (sender.on == true)
    {
        //跳转到设置手势界面
        GestureSetController *gestureVc = [[GestureSetController alloc] init];
        gestureVc.type = GestureViewControllerTypeSetting;
        [self.navigationController pushViewController:gestureVc animated:YES];
    }
    else
    {
        //关闭 跳转到验证手势界面
        GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
        [self.navigationController pushViewController:gestureVerifyVc animated:YES];
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
