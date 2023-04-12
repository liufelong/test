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

@end
