//
//  FLUser.m
//  BookRead
//
//  Created by 刘飞龙 on 2022/9/1.
//

#import "FLUser.h"
#import "FCFileManager.h"

#define BookArrayPath [FCFileManager pathForLibraryDirectoryWithPath:@"bookArray.data"]

@implementation FLUser

static FLUser *user = nil;
static dispatch_once_t onceToken;

+ (instancetype)user {
    dispatch_once(&onceToken, ^{
        user = [[FLUser alloc] init];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:BookArrayPath];
        user.bookArray = @[].mutableCopy;
        [user.bookArray addObjectsFromArray:arr];
        
        //字体大小
        NSString *size = [[NSUserDefaults standardUserDefaults] valueForKey:@"fontSize"];
        if (!size) {
            size = @"20";
        }
        user.fontSize = size;
        
        NSString *isNight = [[NSUserDefaults standardUserDefaults] valueForKey:@"isNight"];
        if ([isNight isEqualToString:@"1"]) {
            user.isNight = YES;
        }else {
            user.isNight = NO;
        }
        

        NSString *bgName = [[NSUserDefaults standardUserDefaults] valueForKey:@"bgName"];
        if ([FLAlertTool isNullObj:bgName]) {
            bgName = @"pic_theme_Kraft";
        }
        user.bgName = bgName;
    });
    
    return user;
}

- (void)saveBookArray {
    [NSKeyedArchiver archiveRootObject:self.bookArray toFile:BookArrayPath];
}

- (void)setFontSize:(NSString *)fontSize {
    _fontSize = fontSize;
    [[NSUserDefaults standardUserDefaults] setValue:fontSize forKey:@"fontSize"];
    
}

- (void)setIsNight:(BOOL)isNight {
    _isNight = isNight;
    if (isNight) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isNight"];
    }else {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isNight"];
    }
}

- (void)setBgName:(NSString *)bgName {
    _bgName = bgName;
    [[NSUserDefaults standardUserDefaults] setValue:bgName forKey:@"bgName"];
}

@end
