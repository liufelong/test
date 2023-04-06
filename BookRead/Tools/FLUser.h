//
//  FLUser.h
//  BookRead
//
//  Created by 刘飞龙 on 2022/9/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define FLUSER [FLUser user]

@interface FLUser : NSObject

+ (instancetype)user;

@property (strong, nonatomic) NSMutableArray *bookArray;

/*!字体大小*/
@property (copy, nonatomic) NSString *fontSize;

/*!是否为夜晚模式*/
@property (assign, nonatomic) BOOL isNight;

/*!日间模式的背景名称*/
@property (copy, nonatomic) NSString *bgName;

- (void)saveBookArray;

@end

NS_ASSUME_NONNULL_END
