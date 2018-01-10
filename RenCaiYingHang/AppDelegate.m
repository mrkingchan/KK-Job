//
//  AppDelegate.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "AppDelegate.h"

// 引入JPush功能所需头文件
#import <JPUSHService.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import <AMapFoundationKit/AMapFoundationKit.h>

#import "ViewController.h"
#import "OSGuideViewController.h"
#import "GestureSetController.h"

@interface AppDelegate ()<OSGuideSelectDelegate,JPUSHRegisterDelegate>

@property (nonatomic,assign) BOOL isEnterBackground;

@end

static NSString *pushappKey = @"8ff9fa7a21f9ab75fcef566a";
static NSString *pushchannel = @"App Store";
static BOOL isProduction = false;//false true

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    /** crash Application windows are expected to have a root **/
    self.window.rootViewController = [[UIViewController alloc] init];
    
    [self gestureAuth];
    /** 是否进入后台操作了 */
    //_isEnterBackground = false;
    
    /** 获取是否存在缓存 */
    [self gainUserModel];
    
    //注册极光
    [self regsiterJPush:launchOptions];
    
    //注册高德
    [AMapServices sharedServices].apiKey = MAMapKey;
    
    //向微信注册
    [WXApi registerApp:WeXinAppID];
    
    /** 自定制广告页 */
    [self diyLaunchView];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


/** 自定制广告页 */
- (void) diyLaunchView
{
    ViewController * viewController = [[ViewController alloc] init];
    viewController.pushCallBack = ^{
        [self jungleToJump];
    };
    self.window.rootViewController = viewController;
}

/** 根据不同的形式跳转 */
- (void) jungleToJump
{
    /** 新版本引导页出现 */
    if ([OSGuideViewController isShow]) {
        OSGuideViewController * guide = [[OSGuideViewController alloc] init];
        self.window.rootViewController = guide;
        guide.delegate = self;
        [guide guidePageControllerWithImages:@[@"pager1",@"pager2"]];
    }else{
        [self clickEnter];
    }
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
            if ([UserInfo.userInfo.reCode isEqualToString:@"X3333"]) {
                [UtilityHelper noRecodeInsertApp];
            }else{
                [UtilityHelper insertApp];
            }
        }
    }
}

/** 用户缓存 **/
- (void) gainUserModel
{
    NSData * data = [RYDefaults objectForKey:[NSString stringWithFormat:UserCache]];
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

/** 注册极光 */
- (void) regsiterJPush:(NSDictionary *)launchOptions
{
    // 注册获得device Token
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:pushappKey
                          channel:pushchannel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            [RYDefaults setObject:registrationID forKey:@"jgRegId"];
            NSLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
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

/** 支付宝回掉 **/
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

#pragma mark - 极光推送

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
    NSString * type = userInfo[@"pushType"];
    NSDictionary * info = userInfo[@"aps"];
    
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive && [type isEqualToString:@"user"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserJPushNotification" object:info];
    }
}



- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        //去注册通知
        [self application:application didReceiveRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    //[JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //去注册通知
         [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
        //去注册通知
        [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:0 format:NULL error:NULL];
    [NSPropertyListSerialization  propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return str;
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
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
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
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
