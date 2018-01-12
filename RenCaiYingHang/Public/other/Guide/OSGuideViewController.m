//
//  OSGuideViewController.m
//  OSNewFrame
//
//  Created by Macx on 2017/11/29.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "OSGuideViewController.h"

#define VERSION_INFO_CURRENT @"currentversion"

@interface OSGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation OSGuideViewController

- (void)guidePageControllerWithImages:(NSArray *)images
{
    UIScrollView *gui = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    gui.delegate = self;
    gui.pagingEnabled = YES;
    // 隐藏滑动条
    gui.showsHorizontalScrollIndicator = NO;
    gui.showsVerticalScrollIndicator = NO;
    // 取消反弹
    gui.bounces = NO;
    for (NSInteger i = 0; i < images.count; i ++) {
        [gui addSubview:({
            self.btnEnter = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btnEnter.frame = CGRectMake(kScreenWidth * i, 0,kScreenWidth, kScreenHeight);
            [self.btnEnter setAdjustsImageWhenHighlighted:false];
            //setImage
            [self.btnEnter setBackgroundImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];;
            self.btnEnter;
        })];
    
        if (i == images.count - 1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"点击进入" forState:UIControlStateNormal];
            btn.frame = CGRectMake(kScreenWidth * i, kScreenHeight - 50, 100, 30);
            btn.center = CGPointMake(kScreenWidth / 2, kScreenHeight - 60);
            btn.layer.cornerRadius = 4;
            btn.clipsToBounds = YES;
            btn.backgroundColor = [UIColor lightGrayColor];
            [btn addTarget:self action:@selector(clickEnter) forControlEvents:UIControlEventTouchUpInside];
            [self.btnEnter addSubview:btn];
        }
//        [self.btnEnter addSubview:({
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [btn setTitle:@"跳过" forState:UIControlStateNormal];
//            if (i == images.count - 1) {
//                [btn setTitle:@"点击进入" forState:UIControlStateNormal];
//            }
//            btn.frame = CGRectMake(kScreenWidth * i, kScreenHeight - 50, 100, 30);
//            btn.center = CGPointMake(kScreenWidth / 2, kScreenHeight - 60);
//            btn.layer.cornerRadius = 4;
//            btn.clipsToBounds = YES;
//            btn.backgroundColor = [UIColor lightGrayColor];
//            [btn addTarget:self action:@selector(clickEnter) forControlEvents:UIControlEventTouchUpInside];
//            btn;
//        })];
    }
    gui.contentSize = CGSizeMake(kScreenWidth * images.count, 0);
    [self.view addSubview:gui];
    
    // pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, 30)];
    self.pageControl.center = CGPointMake(kScreenWidth / 2, kScreenHeight - 95);
    [self.view addSubview:self.pageControl];
    self.pageControl.currentPageIndicatorTintColor = kNavBarTintColor;
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.numberOfPages = images.count;
}

- (void)clickEnter
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickEnter)]) {
        [self.delegate clickEnter];
    }
}
+ (BOOL)isShow
{
    // 读取版本信息
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [user objectForKey:VERSION_INFO_CURRENT];
    NSString * currentVersion = AppVersion;
    if (localVersion == nil || ![currentVersion isEqualToString:localVersion]) {
        [OSGuideViewController saveCurrentVersion];
        return YES;
    }else
    {
        return NO;
    }
}
// 保存版本信息
+ (void)saveCurrentVersion
{
    NSString *version = AppVersion;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:version forKey:VERSION_INFO_CURRENT];
    [user synchronize];
}

#pragma mark - ScrollerView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / kScreenWidth;
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
