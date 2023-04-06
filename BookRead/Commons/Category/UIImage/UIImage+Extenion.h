//
//  UIImage+Extenion.h
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extenion)

#pragma mark - 颜色生成图片
+ (UIImage *)createImageWithColor:(UIColor *)color andSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
