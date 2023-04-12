//
//  NSString+FLString.h
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FLString)

/*!
 @brief 取金额有效位
  4.00 转 4
 */
- (nonnull NSString *)getSignificantFigures;

@end

NS_ASSUME_NONNULL_END
