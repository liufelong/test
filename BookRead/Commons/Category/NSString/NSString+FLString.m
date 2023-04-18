//
//  NSString+FLString.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/12.
//

#import "NSString+FLString.h"

@implementation NSString (FLString)

#pragma mark 取金额有效位
- (nonnull NSString *)getSignificantFigures {
    const char *floatChars = [self UTF8String];
    NSUInteger length = [self length];
    NSUInteger zeroLength = 0;
    NSInteger i = length-1;
    if ([self rangeOfString:@"."].location == NSNotFound) {
        return self;
    }
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0') {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [self substringToIndex:i+1];
    }
    return returnString;
}

#pragma mark - 计算字符串高度(UILabel)
- (CGFloat)compressedSizeInLabelWithWidth:(float)theWidth fontSize:(CGFloat)font {
    static UILabel *sizingLabel;
    static dispatch_once_t onceTokenForSizingLabel;
    dispatch_once(&onceTokenForSizingLabel, ^{
        sizingLabel = [[UILabel alloc] init];
        [sizingLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [sizingLabel setNumberOfLines:0];
    });
    sizingLabel.frame = CGRectMake(0, 0, theWidth, 1000);
    sizingLabel.font = CustomFont(font);
    sizingLabel.text = self;
    CGRect frame = [sizingLabel textRectForBounds:sizingLabel.frame limitedToNumberOfLines:0];
    return frame.size.height;
}
- (CGFloat)compressedSizeInLabelWithWidth:(float)theWidth font:(UIFont*)font {
    CGRect titleRect = [self boundingRectWithSize:CGSizeMake(theWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil];
    return ceil(titleRect.size.height);
}

#pragma mark - 计算字符串高度(UITextView)
- (CGFloat)compressedSizeInTextViewWithWidth:(float)theWidth fontSize:(CGFloat)font {
    static UITextView *sizingTextView;
    static dispatch_once_t onceTokenForSizingLabel;
    dispatch_once(&onceTokenForSizingLabel, ^{
        sizingTextView = [[UITextView alloc] init];
    });
    sizingTextView.frame = CGRectMake(0, 0, theWidth, 1000);
    sizingTextView.font = CustomFont(font);
    sizingTextView.text = self;
    CGSize sizeToFit = [sizingTextView sizeThatFits:CGSizeMake(theWidth, MAXFLOAT)];
    return sizeToFit.height;
}

#pragma mark - 计算字符串宽度
- (CGFloat)getStringWidthWithFontSize:(CGFloat)fontSize {
    NSDictionary *attribute = @{NSFontAttributeName:CustomFont(fontSize)};
    CGSize size = [self boundingRectWithSize:CGSizeMake(0, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return ceil(size.width);
}
- (CGFloat)getStringWidthWithFont:(UIFont*)font{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize size = [self boundingRectWithSize:CGSizeMake(0, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return ceil(size.width);
}

- (CGFloat)getStringHeightWithWidth:(CGFloat)width fontSize:(CGFloat)fontsize {
    CGRect titleRect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:CustomFont(fontsize)} context:nil];
    
    return ceil(titleRect.size.height);
}

- (int)calculateLength {
    int asciiLength = 0;
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar uc = [self characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}

@end
