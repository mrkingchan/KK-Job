//
//  RYSelectViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2018/1/9.
//  Copyright © 2018年 Macx. All rights reserved.
//

#import "RYSelectViewController.h"

#import "PCCircleViewConst.h"

#import "NecessaryInfoViewController.h"
#import "HomePageViewController.h"

@interface RYSelectViewController ()

@end

@implementation RYSelectViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择您的角色";
    [self configurationReturnBack];
    [self initButtons];
}

/** 返回 */
- (void) configurationReturnBack
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE(@"nav_back") style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
}

/** 创建按钮 */
- (void) initButtons
{
    for (int i = 0; i < 2; i++) {
        UIButton * button = [UIFactory initButtonWithFrame:CGRectMake(kScreenWidth * 0.2,KNavBarHeight + (kScreenHeight - KNavBarHeight - kScreenWidth * 0.6 * 0.6 * 2)/3 * (i+1) + kScreenWidth * 0.6 * 0.6*i,kScreenWidth * 0.6, kScreenWidth * 0.6 * 0.6) title:@[@"求职",@"招聘"][i] textColor:kWhiteColor font:systemOfFont(20) cornerRadius:10 tag:i+10 target:self action: @selector(buttonClick:)];
        button.backgroundColor = kNavBarTintColor;
        [self.view addSubview:button];
    }
}

/** 返回 */
- (void) returnBack
{
    [UserInfo loginOut];
    [RYDefaults setObject:@"" forKey:[NSString stringWithFormat:UserCache]];
    [PCCircleViewConst saveGesture:nil Key:gestureFinalSaveKey];
    [[NSUserDefaults standardUserDefaults] setObject:@"close" forKey:@"setOn"];
    UIViewController * loginCtl = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[RYNavigationController alloc] initWithRootViewController:loginCtl];
}

/** 选择端 */
- (void) buttonClick:(UIButton *) sender
{
    switch (sender.tag) {
        case 10:
        {
            [self.navigationController pushViewController:[[NecessaryInfoViewController alloc] init] animated:true];
        }
            break;
        case 11:
        {
            [UIApplication sharedApplication].keyWindow.rootViewController = [[HomePageViewController alloc] init];
        }
            break;
        default:
            break;
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
