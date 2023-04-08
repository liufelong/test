//
//  RequestTool.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/23.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "RequestTool.h"
//#import "LoginViewController.h"
#import <AFNetworking.h>
#import "SVProgressHUD.h"

#define urlSheme @"http://115.159.42.248:8081/" //服务器


static AFHTTPSessionManager *manager = nil;
static RequestTool *requestTool = nil;
@implementation RequestTool

+ (RequestTool *)tool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        requestTool = [[self alloc] init];
        [requestTool checkInterNet];
    });
    return requestTool;
}

- (void)requsetWithUrl:(NSString *)url
                  body:(NSDictionary *)body
               Success:(void (^)(id  _Nonnull result))success
            andFailure:(void(^)(NSString *errorType))failure {
    
    NSDate * today = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:today];
    // 转换成当地时间
    NSDate *localeDate = [today dateByAddingTimeInterval:interval];
    // 时间转换成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:body];
//    [parameters setValue:timeSp forKey:@"timestamp"];
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@--->%@",url,jsonStr);
    
    NSString *showMessage = parameters[@"showMessage"];//@"请稍后...";
    if (showMessage.length > 0) {
        [parameters removeObjectForKey:@"showMessage"];
    }else {
        showMessage = @"请稍后...";
    }
    
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",urlSheme,url];
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    
    [manager POST:urlStr parameters:parameters headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [SVProgressHUD dismiss];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//        NSString *resultString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@--->%@",urlStr,dict);
        success(dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络错误");
    }];
}

- (void)checkInterNet {
    //网络状态
    AFNetworkReachabilityManager *networkReachbilityManager=[AFNetworkReachabilityManager sharedManager];
    [networkReachbilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"断网");
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showErrorWithStatus:@"网络出现问题"];
                [SVProgressHUD dismissWithDelay:2];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                break;
            default:
                break;
        }
    }];
    [networkReachbilityManager startMonitoring];
}


- (void)requsetGetWithUrl:(NSString *)url
                  Success:(void (^)(id  _Nonnull result))success
               andFailure:(void(^)(NSString *errorType))failure {
    
    [SVProgressHUD show];
    NSLog(@"get请求地址: %@",url);
    [manager GET:url parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];

        success(responseObject);
        NSLog(@"请求成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        [SVProgressHUD dismiss];
    }];
}


- (void)requsetGetDownloadWithUrl:(NSString *)url
                          Success:(void (^)(id  _Nonnull result))success
                       andFailure:(void(^)(NSString *errorType))failure {
    
    NSLog(@"下载请求地址: %@",url);
    [manager GET:url parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        success(responseObject);
        NSLog(@"请求成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
}

- (void)requsetPostWithUrl:(NSString *)url
                      body:(NSDictionary *)body
                   Success:(void (^)(id  _Nonnull result))success
                andFailure:(void(^)(NSString *errorType))failure {
    
    if (url.length < 0) {
        failure(@"链接为空");
        return;
    }
    
    NSMutableDictionary *dict = [FLReaderTool readerJsonDictionryWithFiledName:url];
    success(dict);
}


@end
