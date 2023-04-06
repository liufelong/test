//
//  FLBookModel.m
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/17.
//

#import "FLBookModel.h"

@implementation FLBookModel

-(instancetype)init {
    self = [super init];
    if (self) {
        self.chapterArr = @[].mutableCopy;
    }
    return self;
}


- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [self mj_encode:coder];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    if (self) {
        [self mj_decode:coder];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"value:%@,undefineKey:%@",value,key);
}

@end


@implementation FLTapModel


- (void)setColorstring:(NSString *)colorstring {
    _colorstring = colorstring;
    
    
    //将字符串转成颜色
    NSString *cString = [[colorstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    if (cString.length != 6) {
        self.colorUi = CX_COLOR_666;
        return;
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r,g,b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    self.colorUi = [UIColor colorWithRed:((float)r / 255.0f)
                                   green:((float)g / 255.0f)
                                    blue:((float)b / 255.0f)
                                   alpha:1.0f];
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [self mj_encode:coder];
}

@end
