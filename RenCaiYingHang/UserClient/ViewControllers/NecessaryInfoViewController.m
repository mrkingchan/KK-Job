//
//  NecessaryInfoViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/8.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "NecessaryInfoViewController.h"

#import "ReviseNecessaryViewController.h"

#import "RYAlertSheet.h"
#import "RYAreaPickView.h"

#import "JHUploadImage.h"

@interface NecessaryInfoViewController ()<UITableViewDelegate,UITableViewDataSource,PGDatePickerDelegate,JHUploadImageDelegate>
{
    RYAreaPickView * pickView;
}

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,copy) NSArray * dataArray;

@property (nonatomic,retain) UIView * headerView;

@property (nonatomic,retain) UIView * footerView;

@property (nonatomic,strong) NSMutableArray * postArr;

@end

static NSString * UITableViewCellID = @"Cell";

@implementation NecessaryInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 去掉返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:nil];
    // 去掉返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
         _tableView = [UIFactory initTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped delegate:self];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [UIFactory initViewWithFrame:CGRectMake(0, 0, kScreenWidth, 140) color:kWhiteColor];
        UIButton * button = [UIFactory initButtonWithFrame:CGRectMake(0, 0, 80, 80) image:UIIMAGE(@"xxxx") cornerRadius:40 tag:10 target:self action:@selector(setupHeaderIcon:)];
        button.backgroundColor = [UIColor lightGrayColor];
        button.center = _headerView.center;
        [_headerView addSubview:button];
    }
    return _headerView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [UIFactory initViewWithFrame:CGRectMake(0, 0, kScreenWidth, 70) color:nil];
        UIButton * button = [UIFactory initBorderButtonWithFrame:CGRectMake(40, 30, kScreenWidth - 80, 40) title:@"完成" textColor:[UIColor darkTextColor] font:systemOfFont(16) cornerRadius:5 bgColor:kWhiteColor borderColor:[UIColor lightGrayColor] borderWidth:0.5 tag:11 target:self action:@selector(finishClick)];
        [_footerView addSubview:button];
    }
    return _footerView;
}

- (NSMutableArray *)postArr
{
    if (!_postArr) {
        _postArr = [NSMutableArray arrayWithArray:@[@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1"]];
    }
    return _postArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"基本信息";
    self.view.backgroundColor = Color235;
    [self configurationNavigation];
    [self configurationUI];
}

/** 设置UI **/
- (void) configurationUI
{
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    self.dataArray = @[@"姓名",@"性别",@"最高学历",@"工作经验",@"出生年月",@"期望职位",@"期望薪资",@"期望城市"];
    [self.tableView reloadData];
}

/** 设置跳过按钮 */
- (void) configurationNavigation
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(enterClick)];
}

/** 跳过 */
- (void)enterClick
{
    /** 默认进入雷达页面 **/
    [UIApplication sharedApplication].keyWindow.rootViewController = [[RYTabBarController alloc] init];
}

/** 设置头像 */
- (void) setupHeaderIcon:(UIButton *) sender
{
    [JHUPLOAD_IMAGE showActionSheetInFatherViewController:self delegate:self];
}

/** 完成 **/
- (void) finishClick
{
    LoadingView * loading = [[LoadingView alloc] initWithFrame:CGRectZero];
    [loading show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [loading dismiss];
        
        [[NSUserDefaults standardUserDefaults] setObject:@(true) forKey:@"isNecessary"];
        /** 默认进入雷达页面 **/
        [UIApplication sharedApplication].keyWindow.rootViewController = [[RYTabBarController alloc] init];
        [[UIApplication sharedApplication].keyWindow.layer transitionWithAnimType:TransitionAnimTypeRippleEffect subType:TransitionSubtypesFromRamdom curve:TransitionCurveRamdom duration:1.0f];
    });
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
    cell.textLabel.text = self.dataArray[indexPath.row];
    if (![self.postArr[indexPath.row] isEqualToString:@"1"]) {
        cell.detailTextLabel.text = self.postArr[indexPath.row];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0://姓名
        case 5://期望职位
        case 6://期望薪资
        {
            ReviseNecessaryViewController * revieseNecessary = [[ReviseNecessaryViewController alloc] init];
            revieseNecessary.title = self.dataArray[indexPath.row];
            revieseNecessary.maxLength = 18;
            [self.navigationController pushViewController:revieseNecessary animated:true];
            revieseNecessary.reviseNecessaryCall = ^(NSString *string) {
                 [self refreshTableViewWith:indexPath string:string];
            };
        }
            break;
        case 2:{
            [self alertShowWithArr:@[@"博士",@"硕士",@"本科",@"专科",@"其他"] indexPath:indexPath];
        }
            break;
        case 3:{
            [self alertShowWithArr:@[@"10年以上",@"7-10年",@"5-7年",@"3-5年",@"1-3年",@"无经验"] indexPath:indexPath];
        }
            break;
        case 7:
        {
            //选择城市
            [self selectPrvoinceCityAreas:indexPath];
        }
            break;
        case 1:
        {
            //性别
        }
            break;
        case 4:
        {
            //出生年月
            [self showYearMonthPicker];
        }
            break;
        default:
            break;
    }
}

/** 出生年月 */
- (void) showYearMonthPicker
{
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker showWithShadeBackgroud];
    datePicker.datePickerType = PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
    
    NSArray * dateArr =  [[UtilityHelper getCurrentTimes] componentsSeparatedByString:@"-"];
    
    datePicker.minimumDate = [NSDate setYear:1970 month:1];
    datePicker.maximumDate = [NSDate setYear:[dateArr[0] integerValue] month:[dateArr[1] integerValue]];
    
    datePicker.titleLabel.text = @"出生年月";
    //设置线条的颜色
    datePicker.lineBackgroundColor = Color235;
    //设置选中行的字体颜色
    datePicker.textColorOfSelectedRow = [UIColor redColor];
    //设置未选中行的字体颜色
    datePicker.textColorOfOtherRow = [UIColor blackColor];
    //设置取消按钮的字体颜色
    datePicker.cancelButtonTextColor = [UIColor blackColor];
    //设置取消按钮的字
    datePicker.cancelButtonText = @"取消";
    
    //设置确定按钮的字体颜色
    datePicker.confirmButtonTextColor = [UIColor redColor];
    //设置确定按钮的字
    datePicker.confirmButtonText = @"确定";
}

/** 学历,经验,期望城市 **/
- (void) alertShowWithArr:(NSArray *) array indexPath:(NSIndexPath *)indexPath
{
    RYAlertSheet * sheet = [[RYAlertSheet alloc] initWithButtons:array];
    [sheet show];
    
    sheet.ryAlertSheetCall = ^(NSInteger index) {
        [self refreshTableViewWith:indexPath string:array[index]];
    };
}

/** 刷新数据 */
- (void) refreshTableViewWith:(NSIndexPath *)indexPath string:(NSString *)string
{
    [self.postArr replaceObjectAtIndex:indexPath.row withObject:string];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    NSString * string = [NSString stringWithFormat:@"%zd年%zd月",[dateComponents year],[dateComponents month]];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:4 inSection:0];    ;
    [self refreshTableViewWith:indexPath string:string];
}

#pragma mark - JHUploadImageDelegate
- (void)uploadImageToServerWithImage:(UIImage *)image OriginImage:(UIImage *)originImage
{
    for (UIView * view in self.headerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)view;
            button.layer.cornerRadius = 40;
            button.clipsToBounds = true;
            [button setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
    NSLog(@"%@\n%@",originImage,image);
}

/** 选择城市 */
- (void) selectPrvoinceCityAreas:(NSIndexPath *)indexPath
{
    [self closeBeyBoard];
    __weak typeof(self) weakSelf = self;
    [AreaRequest getProvinceInfoWithParamer:nil suceess:^(NSArray *dataArr) {
       
        pickView = nil;
        [pickView removeFromSuperview];
        
        pickView = [[RYAreaPickView alloc] initWithFrame:CGRectZero];
        pickView.provinceArr = dataArr;
        [pickView show];
        
        pickView.selectProvinceCityAreaCall = ^(NSString *province, NSString *city) {
            [weakSelf refreshTableViewWith:indexPath string:city];
        };
       
    } failure:^(id errorCode) {
        
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
