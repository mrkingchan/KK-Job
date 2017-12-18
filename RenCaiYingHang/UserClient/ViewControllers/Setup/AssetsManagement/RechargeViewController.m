//
//  RechargeViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/11.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RechargeViewController.h"

#import "AssetsHandleCell.h"
#import "RechagergeTypeViewCell.h"

@interface RechargeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,copy) NSArray * dataArray;

@property (nonatomic,strong) NSMutableArray * selectButtonArray;

@end

static NSString * AssetsHandleCellID = @"AssetsHandleCell";
static NSString * RechagergeTypeViewCellID = @"RechagergeTypeViewCell";

@implementation RechargeViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [UIFactory initTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped delegate:self];
        [_tableView registerNib:[UINib nibWithNibName:AssetsHandleCellID bundle:nil] forCellReuseIdentifier:AssetsHandleCellID];
        [_tableView registerNib:[UINib nibWithNibName:RechagergeTypeViewCellID bundle:nil] forCellReuseIdentifier:RechagergeTypeViewCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *) tableFooterView
{
    UIView * footer = [UIFactory initViewWithFrame:CGRectMake(0, 0, kScreenWidth, 80) color:nil];
    UIButton * loginOutBtn = [UIFactory initBorderButtonWithFrame:CGRectMake(50, 30, kScreenWidth - 100, 45) title:@"提交" textColor:[UIColor darkTextColor] font:systemOfFont(15) cornerRadius:5 bgColor:kWhiteColor borderColor:[UIColor lightGrayColor] borderWidth:0.5 tag:10 target:self action:@selector(buttonClick:)];
    [footer addSubview:loginOutBtn];
    return footer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"充值";
    [self configurationTableView];
}

- (void) configurationTableView
{
    self.tableView.tableFooterView = [self tableFooterView];
    self.dataArray = @[@"微信支付",@"支付宝支付",@"汇潮支付"];
    [self.tableView reloadData];
}

/** 确认充值 */
- (void) buttonClick:(UIButton *) sender
{
   
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        AssetsHandleCell * cell = [tableView dequeueReusableCellWithIdentifier:AssetsHandleCellID];
        return cell;
    }
    RechagergeTypeViewCell * cell = [tableView dequeueReusableCellWithIdentifier:RechagergeTypeViewCellID];
    cell.title.text = self.dataArray[indexPath.row];
    cell.selectBtn.tag = indexPath.row;
    [cell.selectBtn addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectButtonArray addObject:cell.selectBtn];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0;
    }
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        LabelViewCell * cell = [[NSBundle mainBundle] loadNibNamed:@"LabelViewCell" owner:nil options:nil].lastObject;
        cell.frame = CGRectMake(0, 0, kScreenWidth, 50);
        cell.textLabel.text = @"充值类型";
        return cell;
    }
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        for (UIButton * button in self.selectButtonArray)
        {
            if (button.tag == indexPath.row)
                button.selected = YES;
            else
                button.selected = NO;
        }
    }
}

/** cell 按钮点击事件 */
- (void) cellButtonClick:(UIButton *) sender
{
    for (UIButton * button in self.selectButtonArray)
    {
        if (sender == button)
            button.selected = YES;
        else
            button.selected = NO;
    }
}

- (NSMutableArray *)selectButtonArray
{
    if (!_selectButtonArray) {
        _selectButtonArray = [NSMutableArray array];
    }
    return _selectButtonArray;
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