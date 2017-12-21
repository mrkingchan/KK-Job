//
//  PersonCenterViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "PersonCenterViewController.h"

//#import "SetupViewController.h"
//#import "PrivacyViewController.h"
//#import "UploadResumeViewController.h"
//#import "AssetsManagementViewController.h"

@interface PersonCenterViewController ()

//@property (nonatomic,strong) UITableView * tableView;
//
//@property (nonatomic,copy) NSArray * dataArray;

@end

@implementation PersonCenterViewController

//- (UITableView *)tableView
//{
//    if (!_tableView) {
//        _tableView = [UIFactory initTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped delegate:self];
//        [self.view addSubview:_tableView];
//    }
//    return _tableView;
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:animated];
    self.webView.frame = CGRectMake(0, kStatusBarHeight, kScreenWidth, kScreenHeight - KToolHeight - kStatusBarHeight);
    
    //测试
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?token=%@",KBaseURL,PersonCenter,UserInfo.userInfo.token]]]];
    NSLog(@">>>>%@",[NSString stringWithFormat:@"%@%@?token=%@",KBaseURL,PersonCenter,UserInfo.userInfo.token]);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KBaseURL,PersonCenter]]]];
    
    self.jsMethodName = @"personDetail";
//    self.dataArray = @[@[@"设置",@"隐私设置",@"附近简历",@"资产管理"],@[@"进入企业"]];
//    [self.tableView reloadData];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:self.jsMethodName]) {
        //code...
    }
}

//#pragma mark UITableViewDataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self.dataArray[section] count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString * CellID = @"RYCellID";
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
//    return cell;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.dataArray.count;
//}
//
//#pragma mark UITableViewDelegate
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10.0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section ==  self.dataArray.count - 1) {
//        return 10.0;
//    }
//    return 0.01;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return nil;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    switch (indexPath.section) {
//        case 0:{
//            switch (indexPath.row) {
//                case 0:{
//                    SetupViewController * setup = [[SetupViewController alloc] init];
//                    [self.navigationController pushViewController:setup animated:true];
//                }
//                    break;
//                case 1:{
//                    PrivacyViewController * privacy = [[PrivacyViewController alloc] init];
//                    [self.navigationController pushViewController:privacy animated:true];
//                }
//                    break;
//                case 2:{
//                    UploadResumeViewController * upload = [[UploadResumeViewController alloc] init];
//                    [self.navigationController pushViewController:upload animated:true];
//                }
//                    break;
//                case 3:{
//                    AssetsManagementViewController * assets = [[AssetsManagementViewController alloc] init];
//                    [self.navigationController pushViewController:assets animated:true];
//                }
//                    break;
//                default:
//                    break;
//            }
//        }
//            break;
//        case 1:{
//            /** 如果没有绑定企业了那么就去绑定企业界面 **/
//            /** 默认进入企业端页面 **/
//            [UIApplication sharedApplication].keyWindow.rootViewController = [[RYBusinessTabBarController alloc] init];
//            [[UIApplication sharedApplication].keyWindow.layer transitionWithAnimType:TransitionAnimTypeRippleEffect subType:TransitionSubtypesFromRamdom curve:TransitionCurveRamdom duration:1.0f];
//        }
//            break;
//        default:
//            break;
//    }
//}

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
