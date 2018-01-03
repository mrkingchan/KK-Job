//
//  VerifyHelper.m
//  TalentsBlank
//
//  Created by Macx on 2017/11/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "VerifyHelper.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation VerifyHelper

/** 是否为空 **/
+ (BOOL)empty:(id)value
{
    if ([value isKindOfClass:[NSNull class]] || value == nil) {
        return true;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value isEqualToString:@""] || [[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
    }
    else if ([value isKindOfClass:[NSArray class]]) {
        return [(NSArray *)value count] == 0;
    }
    else if ([value isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)value count] == 0;
    }
    return false;
}

/** 判断字典value是否存在 **/
+(BOOL)isNull:(NSDictionary *)dict key:(NSString*)key
{
    // judge nil
    if(![dict objectForKey:key]){
        return NO;
    }
    
    id obj = [dict objectForKey:key];// judge NSNull
    
    BOOL isNull = [obj isEqual:[NSNull null]];
    return isNull;
}

/** 验证身份证 **/
+ (BOOL)validateIDCardNumber:(NSString *)identityCard
{
    //判断是否为空
    if (identityCard==nil||identityCard.length <= 0  ) {
        return NO;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:identityCard]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [identityCard substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
    //判断校验位
    if(identityCard.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[identityCard substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[identityCard substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
//    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//
//    // 省份代码
//    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41",@"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
//
//    NSString *valueStart2 = [value substringToIndex:2];
//
//    BOOL areaFlag = NO;
//
//    for (NSString *areaCode in areasArray) {
//
//        if ([areaCode isEqualToString:valueStart2]) {
//            areaFlag =YES;
//            break;
//        }
//    }
//
//    if (!areaFlag) {
//        return NO;
//    }
//
//
//    NSRegularExpression *regularExpression;
//    NSUInteger numberofMatch;
//    int year =0;
//    switch (length) {
//        case 15:{
//            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
//            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
//                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]@{5}[0-9]@{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]@{3}$"
//                                                                        options:NSRegularExpressionCaseInsensitive
//                                                                          error:nil];//测试出生日期的合法性
//            }else {
//                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]@{5}[0-9]@{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]@{3}$"
//                                                                        options:NSRegularExpressionCaseInsensitive
//                                                                          error:nil];//测试出生日期的合法性
//            }
//            numberofMatch = [regularExpression numberOfMatchesInString:value
//                                                               options:NSMatchingReportProgress
//                                                                 range:NSMakeRange(0, value.length)];
//
//            if(numberofMatch >0) {
//
//                return YES;
//            }else {
//                return NO;
//            }
//        }
//        case 18:
//            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
//            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
//                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]@{5}((19[0-9]@{2})|(2[0-9]@{3}))((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]@{3}[0-9Xx]$"
//                                                                        options:NSRegularExpressionCaseInsensitive
//                                                                          error:nil];//测试出生日期的合法性
//            }else {
//                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]@{5}((19[0-9]@{2})|(2[0-9]@{3}))((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]@{3}[0-9Xx]$"
//                                                                        options:NSRegularExpressionCaseInsensitive
//                                                                          error:nil];//测试出生日期的合法性
//            }
//            numberofMatch = [regularExpression numberOfMatchesInString:value
//                                                               options:NSMatchingReportProgress
//                                                                 range:NSMakeRange(0, value.length)];
//
//            if(numberofMatch >0) {
//
//                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
//
//                int Y = S %11;
//
//                NSString *M =@"F";
//
//                NSString *JYM =@"10X98765432";
//
//                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
//
//                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
//                    return YES;// 检测ID的校验位
//                }else {
//                    return NO;
//                }
//            }else {
//
//                return NO;
//            }
//        default:
//            return NO;
//    }
}

/** md5加密 **/
+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//电话号码验证
+ (BOOL)checkMobileTel:(NSString *)tel ctl:(UIViewController *) ctl
{
    //香港澳门 8 台湾10
    if(tel.length == 8 || tel.length == 10  || ( tel.length == 11 && [tel hasPrefix:@"1"])){
        return YES;
    }else{
        [ctl showAlertWithTitle:@"手机号不正确" message:@"" appearanceProcess:^(EJAlertViewController * _Nonnull alertMaker) {
            alertMaker.addActionCancelTitle(@"确定");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, EJAlertViewController * _Nonnull alertSelf) {
            
        }];
        return NO;
    }
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
