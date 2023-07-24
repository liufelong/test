//
//  FLAlertTool.m
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/30.
//

#import "FLAlertTool.h"

@implementation FLAlertTool

#pragma mark - **********判空**********

+ (NSString *)makeSureValue:(id)value {
    if (value == nil || value == NULL || [value isKindOfClass:[NSNull class]]) {
        return @"";
    } else if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", value];
    }
    return @"";
}

+ (BOOL)isNullObj:(id)obj {
    if (obj == nil || obj == NULL) {
        return YES;
    }
    if ([obj isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        if ([[obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 ||
            [@"(null)" isEqualToString:(NSString*)obj]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - **********提示框**********

+ (void)alertWithTitle:(NSString *)title {
    [self alertWithTitle:title message:@"" actionTitle1:nil actionTitle2:@"确定" cancelBlock:nil confirmBlock:nil];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    if ([self isNullObj:message]) {
        message = @"数据校验失败";
    } else if ([message isEqualToString:@"(null)"] || [message isEqualToString:@"null"]) {
        message = @"数据校验失败";
    }
    [self alertWithTitle:title message:message actionTitle1:nil actionTitle2:@"确定" cancelBlock:nil confirmBlock:nil];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message sureBlock:(VoidBlock)sureBlock {
    [self alertWithTitle:title message:message actionTitle1:nil actionTitle2:@"确定" cancelBlock:nil confirmBlock:sureBlock];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message confirmBlock:(VoidBlock)confirmBlock {
    [self alertWithTitle:title message:message actionTitle1:@"取消" actionTitle2:@"确定" cancelBlock:nil confirmBlock:confirmBlock];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message confirmBlock:(VoidBlock)confirmBlock cancelBlock:(VoidBlock)cancelBlcok {
    [self alertWithTitle:title message:message actionTitle1:@"取消" actionTitle2:@"确定" cancelBlock:cancelBlcok confirmBlock:confirmBlock];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message actionTitle1:(NSString *)actionTitle1 actionTitle2:(NSString *)actionTitle2 cancelBlock:(VoidBlock)cancelBlock confirmBlock:(VoidBlock)confirmBlock {
    UIViewController *currentVc = [self getCurrentVC];
    if (![currentVc isKindOfClass:[UIViewController class]]) {
        currentVc = [UIApplication sharedApplication].delegate.window.rootViewController;
    }
    [self alertWithTitle:title message:message actionTitle1:actionTitle1 actionTitle2:actionTitle2 cancelBlock:cancelBlock confirmBlock:confirmBlock on:currentVc];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message actionTitle1:(NSString *)actionTitle1 actionTitle2:(NSString *)actionTitle2 cancelBlock:(VoidBlock)cancelBlock confirmBlock:(VoidBlock)confirmBlock on:(UIViewController *)controller {
   
    NSMutableAttributedString *attMessage = [[NSMutableAttributedString alloc] initWithString:[self makeSureValue:message] attributes:alertDefaultAttributes];
    [self alertWithTitle:title attributedMessage:attMessage actionTitle1:actionTitle1 actionTitle2:actionTitle2 cancelBlock:cancelBlock confirmBlock:confirmBlock on:controller];
}

+ (void)alertWithTitle:(NSString *)title attributedMessage:(NSMutableAttributedString *)message actionTitle1:(NSString *)actionTitle1 actionTitle2:(NSString *)actionTitle2 cancelBlock:(VoidBlock)cancelBlock confirmBlock:(VoidBlock)confirmBlock {
    
    UIViewController *currentVc = [self getCurrentVC];
    if (![currentVc isKindOfClass:[UIViewController class]]) {
        currentVc = [UIApplication sharedApplication].delegate.window.rootViewController;
    }
    [self alertWithTitle:title attributedMessage:message actionTitle1:actionTitle1 actionTitle2:actionTitle2 cancelBlock:cancelBlock confirmBlock:confirmBlock on:currentVc];
}
+ (void)alertWithTitle:(NSString *)title attributedMessage:(NSMutableAttributedString *)message actionTitle1:(NSString *)actionTitle1 actionTitle2:(NSString *)actionTitle2 cancelBlock:(VoidBlock)cancelBlock confirmBlock:(VoidBlock)confirmBlock on:(UIViewController *)controller{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message.mutableString preferredStyle:UIAlertControllerStyleAlert];
        
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithString:[self makeSureValue:title]];
    [attTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium],NSForegroundColorAttributeName:CX_COLOR_333} range:NSMakeRange(0, title.length)];
    [alertController setValue:attTitle forKey:@"attributedTitle"];
            
    [alertController setValue:message forKey:@"attributedMessage"];
    
    if (actionTitle1) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:actionTitle1 style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        [cancelAction setValue:CX_COLOR_999 forKey:@"titleTextColor"];
        [alertController addAction:cancelAction];
    }
    if (actionTitle2) {
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:actionTitle2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (confirmBlock) {
                confirmBlock();
            }
        }];
        [confirmAction setValue:CX_MAIN_COLOR forKey:@"titleTextColor"];
        [alertController addAction:confirmAction];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [controller presentViewController:alertController animated:YES completion:nil];
    });
}

+ (UIViewController *)getCurrentVC {
    UIViewController *currentVC = [[UIViewController alloc] init];
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    id  nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    } else if([appRootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tmpBarVC = (UITabBarController *)appRootVC;
        UINavigationController * nav = (UINavigationController *)tmpBarVC.viewControllers[tmpBarVC.selectedIndex];
        nextResponder = nav.viewControllers.lastObject;
        
    } else if([appRootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)appRootVC;
        nextResponder = nav.viewControllers.lastObject;
        
    } else {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        currentVC = nav.childViewControllers.lastObject;
        
    } else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        currentVC = nav.childViewControllers.lastObject;
    } else {
        
        currentVC = nextResponder;
    }
    return currentVC;
}

@end
