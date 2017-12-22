//
//  UtilityHelper.m
//  TalentsBlank
//
//  Created by Macx on 2017/11/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "UtilityHelper.h"

#import "LoginViewController.h"

#import "GTMBase64.h"

#import <CommonCrypto/CommonCryptor.h>

@implementation UtilityHelper

/** 进入app **/
+ (void) insertApp
{
    [RYUserRequest whetherBaseInfoWithParamer:@{@"token":UserInfo.userInfo.token} suceess:^(BOOL isSendSuccess) {
        if (isSendSuccess) {
            /** 默认进入雷达页面 **/
            [UIApplication sharedApplication].keyWindow.rootViewController = [[RYTabBarController alloc] init];
            [[UIApplication sharedApplication].keyWindow.layer transitionWithAnimType:TransitionAnimTypeRippleEffect subType:TransitionSubtypesFromRamdom curve:TransitionCurveRamdom duration:1.0f];
        }else{
            [UIApplication sharedApplication].keyWindow.rootViewController = [[NecessaryInfoViewController alloc] init];
        }
    } failure:^(id errorCode) {

    }];
    //            /** 如果没有绑定企业了那么就去绑定企业界面 **/
    //            /** 默认进入企业端页面 **/
    //            [UIApplication sharedApplication].keyWindow.rootViewController = [[RYBusinessTabBarController alloc] init];
    //            [[UIApplication sharedApplication].keyWindow.layer transitionWithAnimType:TransitionAnimTypeRippleEffect subType:TransitionSubtypesFromRamdom curve:TransitionCurveRamdom duration:1.0f];
}

/** 缓存数据 */
+ (void) saveUserInfoWith:(NSDictionary *)data
{
    NSDictionary * rel = data[@"rel"];
    [UserInfoManage shareInstance].userInfo =  [[UserModel alloc] initWithDictionary:rel];
    NSData * dataUser  = [NSKeyedArchiver archivedDataWithRootObject:rel];
    [RYDefaults setObject:dataUser forKey:[NSString stringWithFormat:@"RYUserInfo"]];
}

/** 自适应高度 **/
+  (CGFloat) fitHeightWithLabel:(NSString *)currentString size:(CGSize)size font:(UIFont*)font
{
    CGFloat height = [currentString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
    return height;
}

/** 自适应宽度 **/
+  (CGFloat) fitWidthWithLabel:(NSString *)currentString font:(UIFont*)font
{
    CGRect tmpRect = [currentString boundingRectWithSize:CGSizeMake(kScreenWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    CGFloat width = tmpRect.size.width;
    return width;
}

/**
 DES加密
 */
+ (NSDictionary *) encryptParmar:(NSDictionary *)paramer
{
    NSString * jsonStr = [paramer mj_JSONString];
    return @{KDatas:[UtilityHelper encryptUseDES2:jsonStr key:DESKEY]};
}

/** 私钥加密 */
+ (NSDictionary *) encryptPkeyParmar:(NSDictionary *)paramer
{
    NSString * paramerStr = [paramer mj_JSONString];
    NSString * encry = [UtilityHelper encryptUseDES2:paramerStr key:UserInfo.userInfo.pkey];
    return @{KDatas:encry,@"token":UserInfo.userInfo.token};
}

/*
 加密方法
 iv和后台协商
 */
const  Byte iv[] = {1,2,3,4,5,6,7,8};
+ (NSString *) encryptUseDES2:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    NSData *textData =  [plainText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSUInteger dataLength = [textData length];
//    unsigned char buffer[1024];
    
    size_t bufferSize = ([textData length] + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    unsigned char buffer[bufferSize];
    
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [textData bytes], dataLength,
                                          buffer, bufferSize,//1024
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        //ciphertext = [Base64 encode:data];
        ciphertext = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    }
    return ciphertext;
}

/**
 DES解密
 */
+ (NSString *)decryptUseDES2:(NSString *)cipherText key:(NSString *)key
{
    NSString *plaintext = nil;
    NSData *cipherdata = [GTMBase64 decodeString:cipherText];//[Base64 decode:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          nil,//iv
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}

/***
 扫一扫
 **/
+(void)scanRQCode:(UIViewController<SGScanningQRCodeVCDelegate>*)vc
{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        if ([vc isKindOfClass:[RYNavigationController class]]) {
            SGScanningQRCodeVC * scan = [[SGScanningQRCodeVC alloc] init];
            scan.delegate = vc;
            [(RYNavigationController*)vc pushViewController:scan animated:YES];
        }else{
            SGScanningQRCodeVC * scan = [[SGScanningQRCodeVC alloc] init];
            scan.delegate = vc;
            [vc.navigationController pushViewController:scan animated:YES];
        }
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"未检测到您的摄像头, 请在真机上测试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
}

/** 获取当前时间 */
+ (NSString*)getCurrentTimes {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

/** >>>>> 传 token 和 pKey<<<<< **/
+ (NSString *) addUrlToken:(NSString *)urlParamer
{
    NSString * jsonstr =   [@{@"token":UserInfo.userInfo.token,@"pkey":UserInfo.userInfo.pkey} mj_JSONString];
    ;
   return  [NSString stringWithFormat:@"%@%@?token=%@",KBaseURL,urlParamer,[UtilityHelper encryptUseDES2:jsonstr key:DESKEY]];
}

@end
