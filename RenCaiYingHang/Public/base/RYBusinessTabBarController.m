//
//  RYBusinessTabBarController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYBusinessTabBarController.h"

#import "HomePageViewController.h"
#import "CompanyCenterViewController.h"

@interface RYBusinessTabBarController ()

@end

@implementation RYBusinessTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addViewControllers];
}

- (void) addViewControllers
{
    [self addChildViewController:[[HomePageViewController alloc] init] navTitle:@"职位" tabbarTitle:@"推荐" tabbarImage:@"1"];
    [self addChildViewController:[[CompanyCenterViewController alloc] init] navTitle:@"企业总心" tabbarTitle:@"企业" tabbarImage:@"2"];
}

- (void)addChildViewController:(UIViewController *)controller navTitle:(NSString *)navTitle tabbarTitle:(NSString *)tabbarTitle tabbarImage:(NSString *)tabbarImage{
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = UIColorHex(999999);
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor darkTextColor];
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
