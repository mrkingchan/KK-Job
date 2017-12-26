//
//  JobViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "JobViewController.h"

#import "JobH5ViewController.h"
#import "RadarViewController.h"

@interface JobViewController ()

@end

@implementation JobViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:animated];
    self.selectIndex = 1;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
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
    jobH5.url = [UtilityHelper addUrlToken:@"public/job/search"];
    jobH5.progressViewColor = [UIColor redColor];
    [self addChildViewController:jobH5];
    
    RadarViewController * recentMap = [[RadarViewController alloc] init];
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
