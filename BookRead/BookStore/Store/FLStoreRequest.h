//
//  FLStoreRequest.h
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLStoreRequest : NSObject

//列表请求数据
+ (void)requestStoreInfoWithBody:(NSDictionary *)body
                      andSuccess:(void (^)(id result))success
                      andFailure:(void(^)(NSString *errorType))failure;

@end

NS_ASSUME_NONNULL_END
