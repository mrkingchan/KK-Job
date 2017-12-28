//
//  AppDelegate.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "AppDelegate.h"

#import "OSGuideViewController.h"

#import "GestureSetController.h"

@interface AppDelegate ()<OSGuideSelectDelegate>

@property (nonatomic,assign) BOOL isEnterBackground;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [self gestureAuth];
    
    /** 是否进入后台操作了 */
    //_isEnterBackground = false;
    
    /** 获取是否存在缓存 */
    [self gainUserModel];
    
    /** 导航样式 **/
    [self configAppearance];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    /** crash Application windows are expected to have a root **/
    self.window.rootViewController = [[UIViewController alloc] init];
    
    
    //向微信注册
    [WXApi registerApp:WeXinAppID];
    
    /** 新版本引导页出现 */
    if ([OSGuideViewController isShow]) {
        OSGuideViewController * guide = [[OSGuideViewController alloc] init];
        self.window.rootViewController = guide;
        guide.delegate = self;
        [guide guidePageControllerWithImages:@[@"pager1",@"pager2"]];
    }else{
        [self clickEnter];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

/** 判断是否需要手势认证 */
- (void) gestureAuth
{
    //在有手势密码的情况下默认每次进来都需要验证手势密码
    if ([[RYDefaults objectForKey:@"setOn"] isEqualToString:@"open"]) {
        [RYDefaults setObject:@"NoGestureLogin" forKey:@"MineGesture"];
    }
}

/** 登陆 */
- (void) clickEnter
{
    /** 默认进入登录页面 **/  /** 如果已经设置手势密码,那么可以先跳转到手势密码登陆界面,如不执行其后再跳转到登陆页面 */
    if ([[RYDefaults objectForKey:@"MineGesture"] isEqualToString:@"NoGestureLogin"] && [[RYDefaults objectForKey:@"setOn"] isEqualToString:@"open"]) {
        GestureSetController * vc = [GestureSetController new];
        [vc setType:GestureViewControllerTypeLogin];
        self.window.rootViewController = [[RYNavigationController alloc] initWithRootViewController:vc];
    }else{
        if ([VerifyHelper empty:UserInfo.userInfo.token]) {
            UIViewController * loginCtl = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
            self.window.rootViewController = [[RYNavigationController alloc] initWithRootViewController:loginCtl];
            [self.window.layer transitionWithAnimType:TransitionAnimTypeRippleEffect subType:TransitionSubtypesFromRamdom curve:TransitionCurveRamdom duration:1.0f];
        }else{
            [UtilityHelper insertApp];
        }
    }
}

/** 用户缓存 **/
- (void) gainUserModel
{
    NSData * data = [RYDefaults objectForKey:[NSString stringWithFormat:@"RYUserInfo"]];
    if (data) {
        if ([data isKindOfClass:[NSString class]]) {
            if (data.length <= 0) {
                UserInfo.is_login = NO;
            }
        }else{
            //在这里解档
            id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                UserInfo.userInfo = [[UserModel alloc] initWithDictionary:obj];
                UserInfo.is_login = YES;
            }
        }

    }else{
        UserInfo.is_login = NO;
    }
}

- (void)configAppearance
{
    [[UINavigationBar appearance] setTintColor:[UIColor darkTextColor]];
    [[UITabBar appearance] setTintColor:[UIColor darkGrayColor]];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options
{
    //判断是微信还是支付宝操作
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@:",WeXinAppID]].location != NSNotFound){
        return  [WXApi handleOpenURL:url delegate:self];
    }else{
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
        }
        return YES;
    }
}

#pragma mark 微信支付回掉
- (void)onResp:(BaseResp *)resp
{
//    if ([resp isKindOfClass:[SendAuthResp class]])
//    {
//        SendAuthResp *temp = (SendAuthResp *)resp;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"WeXinLoginCallBack" object:self userInfo:@{@"SendAuthResp":temp}];
//    }
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response = (PayResp*)resp;
        switch(response.errCode){
            case 0:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WeXinPayCallBack" object:self userInfo:@{@"PayResp":resp}];
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}

-(void) onReq:(BaseReq*)req
{
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /**进入后台*/
//    _isEnterBackground = true;
//    NSDate *senddate = [NSDate date];
//    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
//    [[NSUserDefaults standardUserDefaults] setObject:date2 forKey:@"lastTime"];
//    NSLog(@"date2时间戳 = %@",date2);
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /**进入前台*/
//    if (_isEnterBackground) {
//        NSDate *senddate = [NSDate date];
//        NSString * current = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
//        NSString * last = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastTime"];
//        if ([current longLongValue] - [last longLongValue] >= 30) {
//            [self clickEnter];
//        }
//        _isEnterBackground = false;
//    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
