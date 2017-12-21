//
//  NetWorkHelper.m
//  TalentsBlank
//
//  Created by Macx on 2017/11/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "NetWorkHelper.h"

#import "LoadingView.h"

@implementation NetWorkHelper


+ (id)sharedAFHTTPManager
{
    static AFHTTPSessionManager *manger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [AFHTTPSessionManager manager];
    });
    return manger;
    
}

+ (void)getWithURLString:(NSString *)urlString
              parameters:(id)parameters
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock
{
    AFHTTPSessionManager *manager = [self sharedAFHTTPManager];
    /**
     *  可以接受的类型
     */
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    /**
     *  请求队列的最大并发数
     */
    manager.operationQueue.maxConcurrentOperationCount = 5;
    /**
     *  请求超时的时间
     */
    manager.requestSerializer.timeoutInterval = 30;
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    
    [self showLoading];
    
    [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            [self disMissLoading];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
            NSLog(@">>>>>>>:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            if (![dic[@"reCode"] isEqualToString:@"X0000"] && [VerifyHelper isNull:dic key:@"reCode"]) {
                [NetWorkHelper showMessage:dic[@"reMsg"]];
                return;
            }
            successBlock(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            [self disMissLoading];
            failureBlock(error);
            NSLog(@"网络异常 - T_T%@", error);
        }
    }];
}


+ (void)postWithURLString:(NSString *)urlString
               parameters:(id)parameters
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock
{
    AFHTTPSessionManager *manager = [self sharedAFHTTPManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
   // manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    
    [self showLoading];
    
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self disMissLoading];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
        BOOL isSucess = [self isSuceessCallBackWithUrlString:urlString response:dic];
        if (successBlock && isSucess) {
            NSLog(@"<<<<<<:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
           successBlock(dic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            [self disMissLoading];
            failureBlock(error);
            NSLog(@"网络异常 - T_T%@", error);
            [NetWorkHelper showMessage:@"网络异常"];
        }
    }];
}

/** 提示框 */
+ (void) showMessage:(NSString *)message
{
    BOOL isExist = false;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    for (id class in window.subviews)
    {
        if ([class isKindOfClass:[UIAlertView class]] || [class isKindOfClass:[UIAlertController class]]) {
            isExist = true;
            return;
        }
    }
    if (!isExist) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:message message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

/** 加载框 **/
+ (void) showLoading
{
    BOOL isExist = false;
    for (UIView * view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[LoadingView class]]) {
            isExist = true;
            return;
        }
    }
    if (!isExist){
        LoadingView * loading = [[LoadingView alloc] initWithFrame:CGRectZero];
        [loading show];
    }
}

/** 移除加载框 **/
+ (void) disMissLoading
{
    for (UIView * view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[LoadingView class]]) {
            LoadingView * load = (LoadingView *) view;
            [load dismiss];
        }
    }
}

/** 接口回掉 **/
+ (BOOL) isSuceessCallBackWithUrlString:(NSString * )urlString response:(NSDictionary *) dic
{
    if (([urlString rangeOfString:WhetherBasicInfo].location !=NSNotFound) || ([urlString rangeOfString:GetEmailAndIdcard].location !=NSNotFound)) {
        return true;
    }
    
    if ([urlString rangeOfString:LoginPort].location !=NSNotFound && [dic[@"reCode"] isEqualToString:@"X2222"]) {
        return true;
    }
    
    if (![dic[@"reCode"] isEqualToString:@"X0000"] && ![VerifyHelper isNull:dic key:@"reCode"] ) {
        [NetWorkHelper showMessage:dic[@"reMsg"]];
        return false;
    }
    
    return true;
}

@end
