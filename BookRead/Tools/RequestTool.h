//
//  RequestTool.h
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/23.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface RequestTool : NSObject

+ (RequestTool *)tool;
- (void)checkInterNet;

- (void)requsetWithUrl:(NSString *)url
                  body:(NSDictionary *)body
               Success:(void (^)(id  _Nonnull result))success
            andFailure:(void(^)(NSString *errorType))failure;

- (void)requsetGetWithUrl:(NSString *)url
                  Success:(void (^)(id  _Nonnull result))success
               andFailure:(void(^)(NSString *errorType))failure;

//后台悄悄下载的
- (void)requsetGetDownloadWithUrl:(NSString *)url
                          Success:(void (^)(id  _Nonnull result))success
                       andFailure:(void(^)(NSString *errorType))failure;

@end

NS_ASSUME_NONNULL_END
