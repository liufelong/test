//
//  UIImage+Extenion.m
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/16.
//

#import "UIImage+Extenion.h"

@implementation UIImage (Extenion)

#pragma mark - 颜色生成图片
+ (UIImage *)createImageWithColor:(UIColor *)color andSize:(CGSize)size {
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
