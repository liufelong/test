//
//  FLChapterModel.m
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/17.
//

#import "FLChapterModel.h"

#import <CoreText/CoreText.h>

@implementation FLChapterModel


- (void)pagingWithcontentSize:(CGSize)contentSize {
    
    if (self.text.length == 0) {
        return;
    }
    
    self.textArray = [NSMutableArray new];
    NSMutableDictionary *textAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:FLUSER.fontSize.intValue]}.mutableCopy;
    
    NSString *textString = [NSString stringWithFormat:@"%@\n%@",self.title,self.text];
    
    NSMutableAttributedString *orginAttributeString = [[NSMutableAttributedString alloc] initWithString:textString];
    [orginAttributeString addAttributes:textAttribute range:NSMakeRange(0, textString.length)];
    
    NSMutableDictionary *titleAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:FLUSER.fontSize.intValue + 10]}.mutableCopy;
    [orginAttributeString addAttributes:titleAttribute range:[self.title rangeOfString:textString]];
        
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    //style.lineBreakMode = NSLineBreakByCharWrapping;
//    style.alignment = NSTextAlignmentLeft;
    style.lineSpacing = 10; //  字体的行间距
//    style.headIndent = 0; // 行首缩进
//    style.paragraphSpacing = 4;  // 段与段之间的间距

    [orginAttributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, textString.length)];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:orginAttributeString];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
    [textStorage addLayoutManager:layoutManager];
    
    int I=0;
    while (YES) {
        I++;
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:contentSize];
        [layoutManager addTextContainer:textContainer];
        NSRange rang = [layoutManager glyphRangeForTextContainer:textContainer];
        if(rang.length <= 0)
        {
            break;
        }
        NSString *str = [textString substringWithRange:rang];
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:str attributes:textAttribute];
        [attstr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
        if (rang.location == 0) {
            [attstr addAttributes:titleAttribute range:[str rangeOfString:self.title]];
        }
        [self.textArray  addObject:attstr];
    }
}


- (NSMutableArray *)pagingWithContentString:(NSString *)contentString contentSize:(CGSize)contentSize {
    
    NSMutableDictionary *textAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:FLUSER.fontSize.intValue]}.mutableCopy;
    
    if (![contentString hasPrefix:self.title]) {
        contentString = [NSString stringWithFormat:@"%@\n%@",self.title,contentString];
    }
    
    NSMutableArray *pagingArray = [NSMutableArray array];
    NSMutableAttributedString *orginAttString = [[NSMutableAttributedString alloc] initWithString:contentString attributes:textAttribute];
    
    NSMutableDictionary *titleAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:FLUSER.fontSize.intValue + 10]}.mutableCopy;
    [orginAttString addAttributes:titleAttribute range:[self.title rangeOfString:contentString]];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:orginAttString];
    
    NSLayoutManager* layoutManager = [[NSLayoutManager alloc] init];
    
    [textStorage addLayoutManager:layoutManager];
    
    while (YES) {
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:contentSize];
        [layoutManager addTextContainer:textContainer];

        NSRange rang = [layoutManager glyphRangeForTextContainer:textContainer];
        if (rang.length <= 0) {
            break;
        }
        
        NSMutableAttributedString *attStr =[textStorage attributedSubstringFromRange:rang].mutableCopy;
        
        if (rang.location == 0) {
            [attStr addAttributes:titleAttribute range:NSMakeRange(0, self.title.length)];
        }
        
        [pagingArray addObject:attStr];
    }
    self.textArray = pagingArray;
    return pagingArray;
}

#pragma mark NSCoding,NSCopying
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

//- (nonnull id)copyWithZone:(nullable NSZone *)zone {
//    <#code#>
//}


@end
