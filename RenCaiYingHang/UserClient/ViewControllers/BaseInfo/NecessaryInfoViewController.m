//
//  NecessaryInfoViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/8.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "NecessaryInfoViewController.h"

#import "NecessarySexCell.h"
#import "TextFieldCell.h"
#import "SalaryCell.h"

#import "RYBaseInfoModel.h"

#import "RYAlertAction.h"
#import "RYAreaPickView.h"

@interface NecessaryInfoViewController ()<UITableViewDelegate,UITableViewDataSource,PGDatePickerDelegate,UITextFieldDelegate>
{
    RYAreaPickView * pickView;
    NSInteger cityId;
   
    CGRect origin_rect;
    UITextField * _textField;
    BOOL isAnimation;
}

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,copy) NSArray * dataArray;

@property (nonatomic,retain) UIView * footerView;

@property (nonatomic,strong) RYBaseInfoModel * model;

//学历
@property (nonatomic,copy) NSArray * educationArr;
//经验
@property (nonatomic,copy) NSArray * experienceArr;

@end

static NSString * UITableViewCellID = @"UITableViewCell";
static NSString * NecessarySexCellID = @"NecessarySexCell";
static NSString * TextFieldCellID = @"TextFieldCell";
static NSString * SalaryCellID = @"SalaryCell";

@implementation NecessaryInfoViewController

- (UITableView *)tableView
{
    if (!_tableView) {
         _tableView = [UIFactory initTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped delegate:self];
        [_tableView registerNib:[UINib nibWithNibName:NecessarySexCellID bundle:nil] forCellReuseIdentifier:NecessarySexCellID];
         [_tableView registerNib:[UINib nibWithNibName:TextFieldCellID bundle:nil] forCellReuseIdentifier:TextFieldCellID];
         [_tableView registerNib:[UINib nibWithNibName:SalaryCellID bundle:nil] forCellReuseIdentifier:SalaryCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [UIFactory initViewWithFrame:CGRectMake(0, 0, kScreenWidth, 70) color:nil];
        UIButton * button = [UIFactory initBorderButtonWithFrame:CGRectMake(40, 30, kScreenWidth - 80, 50) title:@"完成" textColor:[UIColor darkTextColor] font:systemOfFont(16) cornerRadius:5 bgColor:kWhiteColor borderColor:[UIColor lightGrayColor] borderWidth:0.5 tag:11 target:self action:@selector(finishClick)];
        [_footerView addSubview:button];
    }
    return _footerView;
}

- (RYBaseInfoModel *)model
{
    if (!_model) {
        _model = [[RYBaseInfoModel alloc] init];
        _model.sex = 1;
    }
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"基本信息";
    self.view.backgroundColor = Color235;
    [self configurationReturnBack];
    [self configurationUI];
    [self addNotification];
    isAnimation = false;
}

/** 自定义返回 */
- (void) configurationReturnBack
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE(@"nav_back") style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
}

/** 返回上一级 */
- (void) returnBack
{
    if ([UserInfo.userInfo.reCode isEqualToString:@"X3333"]) {
        [self.navigationController popViewControllerAnimated:true];
    }else if([UserInfo.userInfo.reCode isEqualToString:@"X1111"]){
        HomePageViewController * homeCtl = [[HomePageViewController alloc] init];
        homeCtl.isFinishComInfo = true;
        [UIApplication sharedApplication].keyWindow.rootViewController = homeCtl;
    }
}

/** 设置UI **/
- (void) configurationUI
{
    self.tableView.tableFooterView = self.footerView;
    
    self.dataArray = @[@"姓名",@"性别",@"最高学历",@"工作经验",@"出生年月",@"期望职位",@"期望薪资",@"期望城市"];
    self.educationArr = @[@"博士以上",@"博士",@"硕士",@"本科",@"大专",@"大专以下",@"其他"];
    self.experienceArr = @[@"10年以上",@"10年",@"9年",@"8年",@"7年",@"6年",@"5年",@"4年",@"3年",@"2年",@"1年",@"应届毕业生"];
    [self.tableView reloadData];
}

/** 完成 **/
- (void) finishClick
{
    /** 有毒的判断 **/
    if ([VerifyHelper empty:self.model.name]) {
        [self alertMessageWithViewController:self message:@"请输入姓名"];
        return;
    }
    
    if (self.model.education == 0){
        [self alertMessageWithViewController:self message:@"最高学历不全"];
        return;
    }
    
    if (self.model.experience == 0){
        [self alertMessageWithViewController:self message:@"工作经验不全"];
        return;
    }
    
    if ([VerifyHelper empty:self.model.birthday]) {
        [self alertMessageWithViewController:self message:@"出生年月不全"];
        return;
    }
    
     if ( [VerifyHelper empty:self.model.job]){
         [self alertMessageWithViewController:self message:@"期望职位不全"];
         return;
    }
    
    if ([VerifyHelper empty:self.model.salary]){
        [self alertMessageWithViewController:self message:@"期望薪资不全"];
        return;
    }
    
    if ([VerifyHelper empty:self.model.city]) {
        [self alertMessageWithViewController:self message:@"期望薪资不全"];
        return;
    }

    NSDictionary * dic = @{@"name":self.model.name,@"gender":@(self.model.sex),@"diploma":@(self.educationArr.count -  self.model.education - 1),@"workyearX":@(self.experienceArr.count - self.model.experience - 1),@"birthday":self.model.birthday,@"expectjob":self.model.job,@"salrange":self.model.salary,@"city":@(cityId)};
    [RYUserRequest uploadBaseInfoWithParamer:dic suceess:^(BOOL isSendSuccess) {
        /** 默认进入雷达页面 **/
        UserInfo.userInfo.reCode = @"X2222";
        [UtilityHelper saveUserInfoWith:UserInfo.userInfo keyName:UserCache];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [[RYTabBarController alloc] init];

    } failure:^(id errorCode) {
        
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
        case 5:
        {
            TextFieldCell * cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
            cell.textLabel.text = self.dataArray[indexPath.row];
            cell.tf.textAlignment = NSTextAlignmentRight;
            cell.tf.placeholder = [NSString stringWithFormat:@"请输入%@",self.dataArray[indexPath.row]];
            cell.textLabel.font = systemOfFont(16);
            
            cell.tf.tag = indexPath.row;
            cell.tf.delegate = self;
            [cell.tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            return cell;
        }
            break;
        case 2:
        case 3:
        case 4:
        case 7:
        {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UITableViewCellID];
            }
            cell.textLabel.text = self.dataArray[indexPath.row];
            cell.textLabel.font = cell.detailTextLabel.font = systemOfFont(16);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.model.education != 0 && indexPath.row == 2){
                cell.detailTextLabel.text = self.educationArr[self.model.education];
            }else if (self.model.experience != 0 && indexPath.row == 3){
                cell.detailTextLabel.text = self.experienceArr[self.model.experience];
            }else if (![VerifyHelper empty:self.model.birthday] && indexPath.row == 4){
                cell.detailTextLabel.text = self.model.birthday;
            }else if (![VerifyHelper empty:self.model.city] && indexPath.row == 7){
                cell.detailTextLabel.text = self.model.city;
            }
            
            return cell;
        }
            break;
        case 1:
        {
            NecessarySexCell * cell = [tableView dequeueReusableCellWithIdentifier:NecessarySexCellID];
            cell.textLabel.text = self.dataArray[indexPath.row];
            cell.textLabel.font = systemOfFont(16);
            cell.NecessarySexSelectCall = ^(NSInteger index) {
                self.model.sex = index;
            };
            return cell;
        }
            break;
        case 6:
        {
            SalaryCell * cell = [tableView dequeueReusableCellWithIdentifier:SalaryCellID];
            
            cell.necessaryMianYiSelectCall = ^(BOOL isSelect) {
                if (isSelect) {
                    self.model.salary = @"0";
                }
            };

            cell.tf.tag = indexPath.row;
            cell.tf.delegate = self;
            [cell.tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
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
    [self closeBeyBoard];
    switch (indexPath.row) {
        case 2:
        {
            [self alertShowWithArr:self.educationArr indexPath:indexPath];
        }
            break;
        case 3:
        {
            [self alertShowWithArr:self.experienceArr indexPath:indexPath];
        }
            break;
        case 7:
        {
            //选择城市
            [self selectPrvoinceCityAreas:indexPath];
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
    datePicker.datePickerMode = PGDatePickerModeDate;
    
    NSArray * dateArr =  [[UtilityHelper getCurrentTimes] componentsSeparatedByString:@"-"];
    
    datePicker.minimumDate = [NSDate setYear:1970 month:1 day:1];
    datePicker.maximumDate = [NSDate setYear:[dateArr[0] integerValue] - 15 month:[dateArr[1] integerValue] day:[dateArr[2] integerValue]];
    
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

/** 学历,经验 **/
- (void) alertShowWithArr:(NSArray *) array indexPath:(NSIndexPath *)indexPath
{
    RYAlertAction * action = [[RYAlertAction alloc] initWithFrame:CGRectZero dataArr:array];
    [action show];
    
    action.ryAlertActionCall = ^(NSInteger index) {
        if (indexPath.row == 2) {
            self.model.education = index;
            [self refreshTableViewWith:indexPath];
        }else if (indexPath.row == 3){
            self.model.experience = index;
            [self refreshTableViewWith:indexPath];
        }
    };
}

/** 刷新数据 */
- (void) refreshTableViewWith:(NSIndexPath *)indexPath
{
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSString * string = [NSString stringWithFormat:@"%zd-%zd-%zd",[dateComponents year],[dateComponents month],[dateComponents day]];
    self.model.birthday = string;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    [self refreshTableViewWith:indexPath];
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
        
        pickView.selectProvinceCityAreaCall = ^(NSString *province, NSString *city,NSInteger cId) {
            cityId = cId;
            weakSelf.model.city = city;
            [weakSelf refreshTableViewWith:indexPath];
        };
       
    } failure:^(id errorCode) {
        
    }];
}

#pragma mark  -键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _textField = textField;
    return true;
}

/** textField的值 **/
- (void) textFieldDidChange:(UITextField *) textField
{
    switch (textField.tag) {
        case 0:
            self.model.name = textField.text;
            break;
        case 5:
            self.model.job = textField.text;
            break;
        case 6:
            self.model.salary = textField.text;
            break;
        default:
            break;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    origin_rect = CGRectMake(0, 0, kScreenWidth , kScreenHeight);
    
    CGFloat h = kScreenHeight - (_textField.tag+1) * 50 - height - KNavBarHeight ;
    
    if (h < 0) {
        
        isAnimation  = true;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, h, kScreenWidth, kScreenHeight);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (isAnimation) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = origin_rect;
            origin_rect = CGRectZero;
        }];
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
