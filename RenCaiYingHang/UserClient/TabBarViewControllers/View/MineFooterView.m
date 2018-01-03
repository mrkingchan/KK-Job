//
//  MineFooterView.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/22.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "MineFooterView.h"

#import "MsgViewCell.h"

@interface MineFooterView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic, strong) NSTimer * timer;

@property (nonatomic, strong) NSMutableArray * msgArr;

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
    [self addTimer];
}

/**设置定时器*/
- (void) addTimer
{
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/** 重排数据 */
- (void) loadData
{
    if (self.msgArr.count == 0) {
        [self removeTimer];
        return;
    }
    NSString * string = self.msgArr[0];
    for (int i = 0; i< self.msgArr.count - 1; i++)
    {
        self.msgArr[i] = self.msgArr[i+1];
    }
    self.msgArr[self.msgArr.count - 1] = string;
    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (NSMutableArray *)msgArr
{
    if (!_msgArr) {
        _msgArr = [NSMutableArray array];
    }
    return _msgArr;
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
    cell.msgLab.text = self.msgArr.count == 0 ? @"":self.msgArr[0];
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

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc
{
    [self removeTimer];
}

@end
