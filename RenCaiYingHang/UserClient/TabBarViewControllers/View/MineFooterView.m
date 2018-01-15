//
//  MineFooterView.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/22.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "MineFooterView.h"

#import "MsgViewCell.h"

//横向跑马灯
#import "CLRollLabel.h"
//竖向跑马灯
#import "GYRollingNoticeView.h"

@interface MineFooterView ()<UITableViewDelegate,UITableViewDataSource,GYRollingNoticeViewDataSource, GYRollingNoticeViewDelegate>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * msgArr;

@property (nonatomic, strong) CLRollLabel * rollLabel;

@end

static NSString * msgLabCellID = @"MsgViewCell";

@implementation MineFooterView

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [UIFactory initTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, self.height) style:UITableViewStyleGrouped delegate:self];
        [_tableView registerNib:[UINib nibWithNibName:msgLabCellID bundle:nil] forCellReuseIdentifier:msgLabCellID];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    for (CenterMessageModel * model in self.dataArr[0]) {
        [self.msgArr addObject:model.content];
    }
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, [self.dataArr[1] count] * 45 + 45 + 20 );
    [self.tableView reloadData];
}

- (NSMutableArray *)msgArr
{
    if (!_msgArr) {
        _msgArr = [NSMutableArray array];
    }
    return _msgArr;
}

- (CLRollLabel *)rollLabel
{
    if (!_rollLabel) {
        _rollLabel = [[CLRollLabel alloc] initWithFrame:CGRectZero font:systemOfFont(15) textColor:[UIColor darkTextColor]];
        _rollLabel.rollSpeed = 0.3;
    }
    return _rollLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //[self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return  1;
    }
    NSLog(@"%zd",[self.dataArr[section] count]);
    return  [self.dataArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSString * cellID = @"CellID";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = UIIMAGE(self.dataArr[indexPath.section][indexPath.row][0]);
        cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row][1];
        cell.textLabel.font = systemOfFont(14);
        return cell;
    }
    MsgViewCell * cell = [tableView dequeueReusableCellWithIdentifier:msgLabCellID];
    if (self.msgArr.count > 0) {
        
//        //横向做法
//        self.rollLabel.frame = CGRectMake(cell.msgLab.left, cell.msgLab.top, kScreenWidth - cell.msgLab.left - 10, cell.msgLab.height);
//        [cell.contentView addSubview:self.rollLabel];
//
//        NSString * string = self.msgArr[0];
//        for (int i = 1; i < self.msgArr.count; i++) {
//            string = [NSString stringWithFormat:@"%@    %@",string,self.msgArr[i]];
//        }
//        self.rollLabel.text = string;
        
        GYRollingNoticeView *noticeView = [[GYRollingNoticeView alloc]initWithFrame:CGRectMake(cell.msgLab.left, cell.msgLab.top, kScreenWidth - cell.msgLab.left - 10, cell.msgLab.height)];
        noticeView.dataSource = self;
        noticeView.delegate = self;
        [cell.contentView addSubview:noticeView];
        noticeView.backgroundColor = [UIColor lightGrayColor];
       
        [noticeView registerClass:[GYNoticeViewCell class] forCellReuseIdentifier:@"GYNoticeViewCell"];
        [noticeView beginScroll];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%zd",self.dataArr.count);
    return self.dataArr.count;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
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
    //回掉
    if (indexPath.section == 1) {
        if (_mineFooterClickCallBack) {
            _mineFooterClickCallBack(indexPath.row);
        }
    }
}

#pragma mark 竖向滚动字体代理
- (NSInteger)numberOfRowsForRollingNoticeView:(GYRollingNoticeView *)rollingView
{
    return self.msgArr.count;
}

- (__kindof GYNoticeViewCell *)rollingNoticeView:(GYRollingNoticeView *)rollingView cellAtIndex:(NSUInteger)index
{
    // 普通用法，只有一行label滚动显示文字
    // normal use, only one line label rolling
    GYNoticeViewCell *cell = [rollingView dequeueReusableCellWithIdentifier:@"GYNoticeViewCell"];
    cell.textLabel.text = self.msgArr[index];
    return cell;
}

- (void)didClickRollingNoticeView:(GYRollingNoticeView *)rollingView forIndex:(NSUInteger)index
{
    NSLog(@"点击的index: %lu", (unsigned long)index);
}

@end
