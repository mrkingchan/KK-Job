//
//  DropInBoxViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "DropInBoxViewController.h"

#import "DropInBoxH5Controller.h"
#import "InterviewH5ViewController.h"

@interface DropInBoxViewController ()

@end

@implementation DropInBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpAllChildViewController];
    [self resetShowStyle];
}

/** 添加子视图 */
- (void) setUpAllChildViewController
{
    DropInBoxH5Controller * jobH5 = [[DropInBoxH5Controller alloc] init];
    jobH5.title = @"投递箱";
    jobH5.url = @"http://www.jianshu.com";
    //jobH5.jsMethodName = @"bbbb";
    jobH5.progressViewColor = [UIColor redColor];
    [self addChildViewController:jobH5];
    
    InterviewH5ViewController * jobH52 = [[InterviewH5ViewController alloc] init];
    jobH52.title = @"已面试";
    jobH52.url = @"https://github.com";
    jobH52.jsMethodName = @"cccc";
    jobH52.progressViewColor = [UIColor redColor];
    [self addChildViewController:jobH52];
}

/** 属性设置 */
- (void) resetShowStyle
{
    [self setUpDisplayStyle:^(UIColor *__autoreleasing *titleScrollViewBgColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIColor *__autoreleasing *proColor, UIFont *__autoreleasing *titleFont, CGFloat *titleButtonWidth, BOOL *isShowPregressView, BOOL *isOpenStretch, BOOL *isOpenShade) {
        
        *titleFont = systemOfFont(17);
        *isShowPregressView = YES;
        *isOpenStretch = YES;
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
