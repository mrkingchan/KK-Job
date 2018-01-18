//
//  JobViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "JobViewController.h"

#import "JobH5ViewController.h"

/** 百度地图 */
#import "BMKRaderViewController.h"

/** 高德地图 */
//#import "MARaderViewController.h"

/** iOS原生地图 */
//#import "RadarViewController.h"

@interface JobViewController ()

@end

@implementation JobViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:animated];
    //self.selectIndex = 1;
    [self requestExprJob];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
}

/** 获取推荐关键词 */
- (void) requestExprJob
{
    NSString * urlString = [NSString stringWithFormat:@"%@securityCenter/ appResumeExpectJob",KBaseURL];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = @{@"token":UserInfo.userInfo.token};
    [NetWorkHelper postWithURLString:urlString parameters:dic success:^(NSDictionary *data) {
        
        NSDictionary * dic = data[@"rel"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"expect_job" object:dic[@"expect_job"]];
        
        [RYDefaults setObject:dic[@"expect_job"] forKey:@"expect_job"];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kNavBarTintColor;
    
    [self setUpAllChildViewController];
    [self resetShowStyle];
}

/** 添加子视图 */
- (void) setUpAllChildViewController
{
    JobH5ViewController * jobH5 = [[JobH5ViewController alloc] init];
    jobH5.title = @"推荐";
    [self addChildViewController:jobH5];
    
    BMKRaderViewController * recentMap = [[BMKRaderViewController alloc] init];
    recentMap.title = @"雷达";
    recentMap.view.backgroundColor = Color235;
    [self addChildViewController:recentMap];
}

/** 属性设置 */
- (void) resetShowStyle
{
    [self setUpDisplayStyle:^(UIColor *__autoreleasing *titleScrollViewBgColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIColor *__autoreleasing *proColor, UIFont *__autoreleasing *titleFont, CGFloat *titleButtonWidth, BOOL *isShowPregressView, BOOL *isOpenStretch, BOOL *isOpenShade) {
        
        *titleFont = systemOfFont(17);
        *isShowPregressView = YES;
        *isOpenStretch = YES;
    }];
    
    UIView * line = [UIFactory initViewWithFrame:CGRectMake(kScreenWidth/2-0.5, kStatusBarHeight, 1, 44) color:Color235];
    [self.view addSubview:line];
    
    self.titleScrollView.layer.borderWidth = 1;
    self.titleScrollView.layer.borderColor = Color235.CGColor;
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
