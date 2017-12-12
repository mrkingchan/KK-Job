//
//  RadarViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RadarViewController.h"

#import "RadarViewCell.h"

@interface RadarViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray * dataArray;

@end

static NSString * RadarViewCellID = @"RadarViewCell";

@implementation RadarViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [UIFactory initTableViewWithFrame:CGRectMake(0, kScreenHeight - KNavBarHeight - 200, 180,kScreenWidth) style:UITableViewStylePlain delegate:self];
        [_tableView registerNib:[UINib nibWithNibName:RadarViewCellID bundle:nil] forCellReuseIdentifier:RadarViewCellID];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.center = CGPointMake(self.view.width/2,kScreenHeight - 200);
        _tableView.transform = CGAffineTransformMakeRotation(- M_PI / 2);
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

- (void) loadData
{
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RadarViewCell * cell = [tableView dequeueReusableCellWithIdentifier:RadarViewCellID];
    cell.radarViewCellButtonClickCall = ^(NSInteger index) {
        //11职位详情,12公司详情
        [self alertMessageWithViewController:self message:index == 11 ?@"职位详情":@"公司详情"];
    };
    cell.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
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
