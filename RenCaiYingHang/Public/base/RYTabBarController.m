//
//  RYTabBarController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYTabBarController.h"

#import "RYTabBar.h"

#import "JobViewController.h"
#import "CompanyViewController.h"
#import "DropInBoxViewController.h"
//#import "PersonCenterViewController.h"
#import "PersonInfoViewController.h"

#import "MMScanViewController.h"
#import "ScanSucessViewController.h"

@interface RYTabBarController ()

@end

@implementation RYTabBarController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[RYDefaults objectForKey:@"notifiInsert"] isEqualToString:@"notifi"]) {
        [RYDefaults setObject:@"" forKey:@"notifiInsert"];
        self.selectedIndex = 2;
    }else if ([[RYDefaults objectForKey:@"notifiInsert"] isEqualToString:@"notifi3"]){
        [RYDefaults setObject:@"" forKey:@"notifiInsert"];
        self.selectedIndex = 3;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addViewControllers];
    [self addMidButton];
}

- (void) addViewControllers
{
    [self addChildViewController:[[JobViewController alloc] init] navTitle:@"公司" tabbarTitle:@"职位" tabbarImage:@"1"];
    [self addChildViewController:[[CompanyViewController alloc] init] navTitle:@"企业" tabbarTitle:@"企业" tabbarImage:@"2"];
    [self addChildViewController:[[DropInBoxViewController alloc] init] navTitle:@"投递箱" tabbarTitle:@"投递箱" tabbarImage:@"3"];
    [self addChildViewController:[[PersonInfoViewController alloc] init] navTitle:@"个人信息" tabbarTitle:@"我的" tabbarImage:@"4"];
}

- (void) addMidButton
{
    RYTabBar * tabBar = [[RYTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    [tabBar setDidMiddBtn:^{
        MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeQrCode onFinish:^(NSString *result, NSError *error) {
            if (error) {
                NSLog(@"error: %@",error);
            } else {
                NSLog(@"扫描结果：%@",result);
                if ([result rangeOfString:KDatas].location !=NSNotFound) {
                    result =  [result componentsSeparatedByString:@"datas="][1];
                    [RYUserRequest scanCodeInterviewAwardWithWithParamer:result suceess:^(NSString *urlString) {
                        [self.selectedViewController pushViewController:[[ScanSucessViewController alloc] init] animated:true];
                    } failure:^(id errorCode) {

                    }];
                }else{
                    [self showAlertWithTitle:@"无效二维码" message:@"" appearanceProcess:^(EJAlertViewController * _Nonnull alertMaker) {
                        alertMaker.addActionCancelTitle(@"确定");
                    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, EJAlertViewController * _Nonnull alertSelf) {

                    }];
                }
            }
        }];
        [self.selectedViewController pushViewController:scanVc animated:YES];
    }];
}

- (void)addChildViewController:(UIViewController *)controller navTitle:(NSString *)navTitle tabbarTitle:(NSString *)tabbarTitle tabbarImage:(NSString *)tabbarImage{
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = UIColorHex(333333);
    selectTextAttrs[NSForegroundColorAttributeName] = UIColorHex(EE5A48);
    [controller.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [controller.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    RYNavigationController *nav = [[RYNavigationController alloc]initWithRootViewController:controller];
    controller.navigationItem.title = navTitle;
    controller.tabBarItem.title = tabbarTitle;
    controller.tabBarItem.image = [[UIImage imageNamed:tabbarImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage= [[UIImage imageNamed:[NSString stringWithFormat:@"%@s",tabbarImage]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
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
