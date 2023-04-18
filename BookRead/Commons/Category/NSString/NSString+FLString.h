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

#pragma mark - 字符串宽高类计算

/*!
 @brief 计算字符串高度(UILabel)
 */
- (CGFloat)compressedSizeInLabelWithWidth:(float)theWidth fontSize:(CGFloat)font;
- (CGFloat)compressedSizeInLabelWithWidth:(float)theWidth font:(UIFont*)font;

/*!
 @brief 计算字符串高度(UITextView)
 */
- (CGFloat)compressedSizeInTextViewWithWidth:(float)theWidth fontSize:(CGFloat)font;

/*!
 @brief 计算字符串宽度
 */
- (CGFloat)getStringWidthWithFontSize:(CGFloat)fontSize;
- (CGFloat)getStringWidthWithFont:(UIFont*)font;
/**
 计算字符串高度
 
 @param width 宽度
 @param fontsize 字号
 @return 字符串高度
 */
- (CGFloat)getStringHeightWithWidth:(CGFloat)width fontSize:(CGFloat)fontsize;

/*!
 @brief    计算字符串长度
 */
- (int)calculateLength;

@end

NS_ASSUME_NONNULL_END
