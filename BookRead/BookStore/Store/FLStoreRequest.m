//
//  FLStoreRequest.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/8.
//

#import "FLStoreRequest.h"

#import "RequestTool.h"

@implementation FLStoreRequest

+ (void)requestStoreInfoWithBody:(NSDictionary *)body
                      andSuccess:(void (^)(id result))success
                      andFailure:(void(^)(NSString *errorType))failure {
    NSString *url = @"storedown";
    
    [FLRequest requsetPostWithUrl:url body:body Success:^(id  _Nonnull result) {
        NSMutableDictionary *dict = (NSMutableDictionary *)result;
        NSMutableDictionary *bodyDic = dict[@"body"];
        success(bodyDic);
        
    } andFailure:^(NSString * _Nonnull errorType) {
        failure(errorType);
    }];
}

@end
