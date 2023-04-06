//
//  FLAlertTool.h
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/30.
//

#import <Foundation/Foundation.h>


#define alertDefaultAttributes @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:CX_COLOR_666}

typedef void (^VoidBlock)(void);

@interface FLAlertTool : NSObject

#pragma mark + **********判空**********
+ (NSString *)makeSureValue:(id)value;
+ (BOOL)isNullObj:(id)obj;
#pragma mark + **********提示框**********
+ (void)alertWithTitle:(NSString *)title;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message confirmBlock:(VoidBlock)confirmBlock;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message confirmBlock:(VoidBlock)confirmBlock cancelBlock:(VoidBlock)cancelBlcok;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message actionTitle1:(NSString *)actionTitle1 actionTitle2:(NSString *)actionTitle2 cancelBlock:(VoidBlock)cancelBlock confirmBlock:(VoidBlock)confirmBlock;
// 在自定义控制器上弹出 alert
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message actionTitle1:(NSString *)actionTitle1 actionTitle2:(NSString *)actionTitle2 cancelBlock:(VoidBlock)cancelBlock confirmBlock:(VoidBlock)confirmBlock on:(UIViewController *)controller;
//添加message使用attributeString
+ (void)alertWithTitle:(NSString *)title attributedMessage:(NSMutableAttributedString *)message actionTitle1:(NSString *)actionTitle1 actionTitle2:(NSString *)actionTitle2 cancelBlock:(VoidBlock)cancelBlock confirmBlock:(VoidBlock)confirmBlock;

/*!一个确定按钮带回调*/
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message sureBlock:(VoidBlock)sureBlock;


@end

