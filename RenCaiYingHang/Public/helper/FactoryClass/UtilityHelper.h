//
//  UtilityHelper.h
//  TalentsBlank
//
//  Created by Macx on 2017/11/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SGScanningQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "SGAlertView.h"

#import "UserModel.h"

@interface UtilityHelper : NSObject

/** 进入app **/
+ (void) insertApp;

/** X3333进来的问题 */
+ (void) noRecodeInsertApp;

/** 切换 **/
+ (void) changeClient:(NSInteger) clientType;

/** 缓存数据 */
+ (void) saveUserInfoWith:(UserModel *)model keyName:(NSString *)keyName;

/** 自适应宽高 **/
+  (CGSize) fitHeightWithLabel:(NSString *)currentString size:(CGSize)size font:(UIFont*)font;

/** DES加密 **/
+ (NSDictionary *) encryptParmar:(NSDictionary *)paramer;

/** 私钥加密 */
+ (NSDictionary *) encryptPkeyParmar:(NSDictionary *)paramer;

/**
 DES加密方式
 */
+ (NSString *) encryptUseDES2:(NSString *)plainText key:(NSString *)key;

/** DES解密方式
 **/
+ (NSString *)decryptUseDES2:(NSString *)cipherText key:(NSString *)key;

/*** 扫一扫 **/
+(void)scanRQCode:(UIViewController<SGScanningQRCodeVCDelegate>*)vc;

/** 生成二维码 **/
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize;

/** 拼接两图 */
+ (UIImage *)composeImg:(UIImage *) img img1:(UIImage *)img1;

/** 获取当前时间 */
+ (NSString*)getCurrentTimes;

/** 提示信息 */
+ (void) alertMessage:(NSString *) message ctl:(UIViewController *) ctl;

/** 存图片 **/
+ (void) cacheImageWithImageName:(NSString *) name image:(UIImage *)image;

/** 拿图片 */
+ (UIImage *) gainImageFromFilePath:(NSString *) name;

/** >>>>> 传 token 和 pKey<<<<< **/
+ (NSString *) addUrlToken:(NSString *)urlParamer;

/** >>>>> 传 token 和 pKey<<<<< **/
+ (NSString *) addTokenForUrlSting:(NSString *)urlString;

@end
