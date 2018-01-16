//
//  UtilityHelper.m
//  TalentsBlank
//
//  Created by Macx on 2017/11/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "UtilityHelper.h"

#import "RYSelectViewController.h"

#import "LoginViewController.h"

#import "GTMBase64.h"

#import <CommonCrypto/CommonCryptor.h>

@implementation UtilityHelper

/** 登陆注册走 **/
+ (void) insertApp
{
    if ([UserInfo.userInfo.reCode isEqualToString:@"X2222"])
    {
        [UIApplication sharedApplication].keyWindow.rootViewController = [[RYTabBarController alloc] init];
    }
    else if([UserInfo.userInfo.reCode isEqualToString:@"X1111"])
    {
        HomePageViewController * homeCtl = [[HomePageViewController alloc] init];
        homeCtl.isFinishComInfo = true;
        [UIApplication sharedApplication].keyWindow.rootViewController = homeCtl;
    }
    else
    {
        RYNavigationController * root = [[RYNavigationController alloc] initWithRootViewController:[[RYSelectViewController alloc] init]];
        [UIApplication sharedApplication].keyWindow.rootViewController = root;
    }
}

/** X3333进来的问题 */
+ (void) noRecodeInsertApp
{
    NSDictionary * paramer = @{@"token":UserInfo.userInfo.token,@"pkey":UserInfo.userInfo.pkey};
    [RYUserRequest whetherBaseInfoWithParamer:paramer suceess:^(NSString * whetherUserBaseInfo,NSDictionary * whetherComBaseInfo) {
    
        if(![[whetherComBaseInfo allKeys] containsObject:@"comUserInfo"]||[whetherUserBaseInfo isEqualToString:@"yes"])
        {
            if (![[whetherComBaseInfo allKeys] containsObject:@"comUserInfo"]) {
                UserInfo.userInfo.reCode = @"X1111";
                UserInfo.userInfo.comId = whetherComBaseInfo[@"com_id"];
                UserInfo.userInfo.comname = whetherComBaseInfo[@"comname"];
                [UtilityHelper saveUserInfoWith:UserInfo.userInfo keyName:UserCache];
                
                HomePageViewController * homeCtl = [[HomePageViewController alloc] init];
                homeCtl.isFinishComInfo = true;
                [UIApplication sharedApplication].keyWindow.rootViewController = homeCtl;
            }
            if ([whetherUserBaseInfo isEqualToString:@"yes"]) {
                UserInfo.userInfo.reCode = @"X2222";
                [UtilityHelper saveUserInfoWith:UserInfo.userInfo keyName:UserCache];
                [UIApplication sharedApplication].keyWindow.rootViewController = [[RYTabBarController alloc] init];
            }
        }else{
            RYNavigationController * root = [[RYNavigationController alloc] initWithRootViewController:[[RYSelectViewController alloc] init]];
            [UIApplication sharedApplication].keyWindow.rootViewController = root;
        }
    } failure:^(id errorCode) {
        
    }];
}

/** 切换 **/
+ (void) changeClient:(NSInteger) clientType
{
    NSDictionary * paramer = @{@"token":UserInfo.userInfo.token,@"pkey":UserInfo.userInfo.pkey};
    [RYUserRequest whetherBaseInfoWithParamer:paramer suceess:^(NSString * whetherUserBaseInfo,NSDictionary * whetherComBaseInfo) {
        
        switch (clientType) {
            case 1: /** 1是个人版跳企业版 */
            {
                if([[whetherComBaseInfo allKeys] containsObject:@"comUserInfo"])
                {
                    UserInfo.userInfo.reCode = @"X3333";
                    [UtilityHelper saveUserInfoWith:UserInfo.userInfo keyName:UserCache];
                    
                    HomePageViewController * homeCtl = [[HomePageViewController alloc] init];
                    homeCtl.isFinishComInfo = false;
                    [UIApplication sharedApplication].keyWindow.rootViewController = homeCtl;
                }
                else if([[whetherComBaseInfo allKeys] containsObject:@"com_id"])
                {
                    UserInfo.userInfo.reCode = @"X1111";
                    UserInfo.userInfo.comId = whetherComBaseInfo[@"com_id"];
                    UserInfo.userInfo.comname = whetherComBaseInfo[@"comname"];
                    [UtilityHelper saveUserInfoWith:UserInfo.userInfo keyName:UserCache];
                    
                    HomePageViewController * homeCtl = [[HomePageViewController alloc] init];
                    homeCtl.isFinishComInfo = true;
                    [UIApplication sharedApplication].keyWindow.rootViewController = homeCtl;
                }
            }
                break;
            case 2:/** 2是企业版跳个人版 */
            {
                if ([whetherUserBaseInfo isEqualToString:@"yes"]) {
                    UserInfo.userInfo.reCode = @"X2222";
                    [UtilityHelper saveUserInfoWith:UserInfo.userInfo keyName:UserCache];
                    
                    [UIApplication sharedApplication].keyWindow.rootViewController = [[RYTabBarController alloc] init];
                    
                }else if ([whetherUserBaseInfo isEqualToString:@"no"]){
                    [UIApplication sharedApplication].keyWindow.rootViewController =  [[RYNavigationController alloc] initWithRootViewController:[[NecessaryInfoViewController alloc] init]];
                }
            }
                break;
            default:
                break;
        }
    } failure:^(id errorCode) {
        
    }];
}

/** 缓存数据 */
+ (void) saveUserInfoWith:(UserModel *)model keyName:(NSString *)keyName
{
    NSDictionary * rel = UserInfo.userInfo.mj_keyValues;
    NSData * dataUser  = [NSKeyedArchiver archivedDataWithRootObject:rel];
    [RYDefaults setObject:dataUser forKey:keyName];
}

/** 自适应宽高 **/
+  (CGSize) fitHeightWithLabel:(NSString *)currentString size:(CGSize)size font:(UIFont*)font
{
    CGSize finSize = [currentString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    //size.height size.width
    return finSize;
}

/** DES加密 */
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

/** DES解密 */
+ (NSString *)decryptUseDES2:(NSString *)cipherText key:(NSString *)key
{
    NSString *plaintext = nil;
    NSData *cipherdata = [GTMBase64 decodeData:[cipherText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
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

/** 生成二维码 **/
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    return [UtilityHelper createNonInterpolatedUIImageFormCIImage:outPutImage withSize:Imagesize waterImageSize:waterImagesize];
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size waterImageSize:(CGFloat)waterImagesize{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
//    //给二维码加 logo 图
//    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
//    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
//    //logo图
//    UIImage *waterimage = [UIImage imageNamed:@"icon_imgApp"];
//    //把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
//    [waterimage drawInRect:CGRectMake((size-waterImagesize)/2.0, (size-waterImagesize)/2.0, waterImagesize, waterImagesize)];
//    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    return outputImage;
}

/** 拼接两图 */
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    
    UIGraphicsBeginImageContext(image1.size);
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake(20, image1.size.height - image2.size.height - 20, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

/** 拼接两图 */
+ (UIImage *)composeImg:(UIImage *) img img1:(UIImage *)img1
{
    CGImageRef imgRef = img.CGImage;
    CGFloat w = CGImageGetWidth(imgRef);
    CGFloat h = CGImageGetHeight(imgRef);
    
    CGImageRef imgRef1 = img1.CGImage;
    CGFloat w1 = CGImageGetWidth(imgRef1);
    CGFloat h1 = CGImageGetHeight(imgRef1);
    
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    [img drawInRect:CGRectMake(0, 0, w, h)];//先把大图 画到上下文中
    [img1 drawInRect:CGRectMake(w/320*50+10, h - h1 - w/320*50, w1, h1)];//再把小图放在上下文中
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
    
    return resultImg;
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

/** 提示信息 */
+ (void) alertMessage:(NSString *) message ctl:(UIViewController *) ctl
{
    [ctl showAlertWithTitle:message message:@"" appearanceProcess:^(EJAlertViewController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"确定");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, EJAlertViewController * _Nonnull alertSelf) {
        
    }];
}

/** 存图片 **/
+ (void) cacheImageWithImageName:(NSString *) name image:(UIImage *)image
{
    NSString *path_document = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_document stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",name]];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
}

/** 拿图片 */
+ (UIImage *) gainImageFromFilePath:(NSString *) name
{
    NSString *path_document = NSHomeDirectory();
    return [UIImage imageWithContentsOfFile:[path_document stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",name]]];
}


/** >>>>> 传 token 和 pKey<<<<< **/
+ (NSString *) addUrlToken:(NSString *)urlParamer
{
    NSString * jsonstr =   [@{@"token":UserInfo.userInfo.token,@"pkey":UserInfo.userInfo.pkey} mj_JSONString];
    ;
   return  [NSString stringWithFormat:@"%@%@?token=%@",KBaseURL,urlParamer,[UtilityHelper encryptUseDES2:jsonstr key:DESKEY]];
}

/** >>>>> 传 token 和 pKey<<<<< **/
+ (NSString *) addTokenForUrlSting:(NSString *)urlString
{
    NSString * jsonstr =   [@{@"token":UserInfo.userInfo.token,@"pkey":UserInfo.userInfo.pkey} mj_JSONString];
    ;
    NSString * accountStr = @"?";
    if ([urlString rangeOfString:accountStr].location != NSNotFound) {
        accountStr = @"&";
    }
    return  [NSString stringWithFormat:@"%@%@token=%@",urlString,accountStr,[UtilityHelper encryptUseDES2:jsonstr key:DESKEY]];
}

@end
