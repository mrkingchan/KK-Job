//
//  RYAlertAction.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/20.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYAlertAction.h"

@interface RYAlertAction()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,copy) NSArray * dataArray;

@end

@implementation RYAlertAction

- (UITableView *)tableView
{
    if (!_tableView) {
        CGFloat h = kScreenHeight - _dataArray.count * 44 - 54;
        if (h < 0) {
            h = 0;
        }
        _tableView = [UIFactory initTableViewWithFrame:CGRectMake(0, h, kScreenWidth, self.bounds.size.height - h - 54) style:UITableViewStylePlain delegate:self];
        _tableView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self initUI:dataArr];
    }
    return self;
}

- (void) initUI:(NSArray *) dataArr
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
    [self addGestureRecognizer:tap];
    
    _dataArray = dataArr;
    [self.tableView reloadData];
    [self initButton];
}

- (void) initButton
{
    UIButton * cancel = [UIFactory initButtonWithFrame:CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44) title:@"取消" textColor:[UIColor darkTextColor] font:systemOfFont(16) cornerRadius:0 tag:0 target:self action:@selector(cancelClick)];
    cancel.backgroundColor = kWhiteColor;
    [self addSubview:cancel];
}

- (void)cancelClick
{
    [self removeFromSuperview];
}

- (void) show
{
    [[UIFactory getKeyWindow] addSubview:self];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * UITableViewCellID = @"UITableViewCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UITableViewCellID];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = cell.detailTextLabel.font = systemOfFont(16);
    
    /** 手势冲突 **/
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellAction:)];
    cell.tag = indexPath.row;
    [cell addGestureRecognizer:tap];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //点击回调
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void) cellAction:(UIGestureRecognizer *)ges {
    if (_ryAlertActionCall) {
        _ryAlertActionCall(ges.view.tag);
    }
    [self cancelClick];
}

@end
