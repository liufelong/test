//
//  FLStoreDataModel.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/7.
//

#import "FLStoreDataModel.h"

@implementation FLStoreDataModel


- (void)createBookList:(NSArray *)booklist {
    self.booklist = @[].mutableCopy;
    for (NSDictionary *bookDict in booklist) {
        FLBookModel *book = [[FLBookModel alloc] init];
        [book setValuesForKeysWithDictionary:bookDict];
        [self.booklist addObject:book];
    }
}

- (void)calculateCellHight {
    if ([self.stype isEqualToString:@"1"]) {
        self.cellHight = 100.f;
        return;
    }
    CGFloat witdh,hight;
    int number = 1;
    if ([self.stype isEqualToString:@"2"]) {
        number = 4;
        witdh = (SCREEN_WIDTH - 39) / number;
        hight = witdh / 0.618;
        self.size = CGSizeMake(witdh, hight);
        
    }else{ // if ([self.stype isEqualToString:@"3"])
        number = 2;
        witdh = (SCREEN_WIDTH - 29) / number;
        hight = witdh * 0.618;
        self.size = CGSizeMake(witdh, hight);
    }
    
    int rowNoumber = self.booklist.count / number;
    if (self.booklist.count % number != 0) {
        rowNoumber = rowNoumber + 1;
    }
    self.cellHight = rowNoumber * hight + rowNoumber * 10;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (id)valueForUndefinedKey:(NSString *)key{
    return @"";
}

@end
