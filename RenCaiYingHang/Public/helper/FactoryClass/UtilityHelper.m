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

#import <MapKit/MapKit.h>

@implementation UtilityHelper

/** 是否登录,return NO 就跳转到登录页面 */
+ (BOOL) isLogin:(UIViewController *) vc
{
    if ([UserInfoManage shareInstance].is_login == NO)
    {
        LoginViewController *advanceCtl=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [vc.navigationController pushViewController:advanceCtl animated:YES];
        return NO;
    }
    return YES;
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
+ (NSString *) encryptParmar:(NSString *)paramer
{
    return [UtilityHelper encryptUseDES2:paramer key:DESKEY];
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

/**
 获取本地数据
 */
+ (NSDictionary *) localDataResourceWithName:(NSString *)name
{
    //@"Directions"
    NSString *strPath = [[NSBundle mainBundle] pathForResource:name ofType:@"geojson"];
    NSString *parseJason = [[NSString alloc] initWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [parseJason dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    return dic;//parseJason.mj_keyValues;
}

/**
 地图导航
 */
+ (void )loadGPSWithLat:(NSString *)latitude log:(NSString *)longitude
{
    //百度地图
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://map/"]])
    {
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",[latitude floatValue],[longitude floatValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    //高德地图
    else if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"人才赢行",@"iosamap",[latitude floatValue],[longitude floatValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    //谷歌地图
    else if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
    {
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"人才赢行",@"comgooglemaps",[latitude floatValue],[longitude floatValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    //苹果地图
    else
    {
        //终点坐标
        CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake([latitude floatValue],[longitude floatValue]);
        //当前位置
        MKMapItem * currentLocation = [MKMapItem mapItemForCurrentLocation];
        //目的地的位置
        MKMapItem * toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1 addressDictionary:nil]];
        toLocation.name = @"目的地";
        
        //        NSString *myname=[dataSource objectForKey:@"name"];
        //
        //        if (![XtomFunction xfunc_check_strEmpty:myname])
        //
        //        {
        //            toLocation.name =myname;
        //        }
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    }
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

@end
