//
//  NetWorkHelper.h
//  TalentsBlank
//
//  Created by Macx on 2017/11/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(NSDictionary *data);
typedef void (^FailureBlock)(NSError *error);

@interface NetWorkHelper : NSObject

@property (nonatomic, copy) SuccessBlock successBlock;
@property (nonatomic, copy) FailureBlock failureBlock;


+(id)sharedAFHTTPManager;

/**
 *  发送get请求
 *
 *  urlString  请求的网址字符串
 *  parameters 请求的参数
 *  success    请求成功的回调
 *  failure    请求失败的回调
 */
+ (void)getWithURLString:(NSString *)urlString
              parameters:(id)parameters
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock;

/**
 *  发送post请求
 *
 *   urlString  请求的网址字符串
 *   parameters 请求的参数
 *   success    请求成功的回调
 *   failure    请求失败的回调
 */
+ (void)postWithURLString:(NSString *)urlString
               parameters:(id)parameters
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock;

@end
