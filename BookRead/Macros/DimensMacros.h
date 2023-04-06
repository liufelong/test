//
//  DimensMacros.h
//  aasipods
//
//  Created by zxyuan on 16/3/18.
//  Copyright © 2016年 zxyuan. All rights reserved.
//

#ifndef DimensMacros_h
#define DimensMacros_h

/************判断设备******************/
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
// iphone4, iphone4s系列
#define IPHONE_4   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
// iphone5, iphone5c，iphone5s系列
#define IPHONE_5     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)

#define IPHONE_X  (isIPhoneXSeries())

static inline BOOL isIPhoneXSeries() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}
/************屏幕适配******************/

//状态栏高度
#define STATUS_BAR_HEIGHT ((IPHONE_X == YES) ? 44.f : 20.f)
//Navigation Bar高度
#define NAVIGATION_BAR_HEIGHT (44.f)
//状态栏＋导航栏 高度
#define STATUS_AND_NAVIGATION_HEIGHT ((STATUS_BAR_HEIGHT) + (NAVIGATION_BAR_HEIGHT))
//Tab Bar高度
#define TAB_BAR_HEIGHT (49.f)
// Tab Safe 高度(iPhone X适配)
#define TAB_SAFE_HEIGHT ((IPHONE_X == YES) ? 34.f : 0.f)
//TabBar + TabSafe 高度
#define TAB_BAR_Safe_HEIGHT ((TAB_BAR_HEIGHT) + (TAB_SAFE_HEIGHT))
//UIButton圆角
#define BUTTON_CORNERRADIUS 5.0

//屏幕
#define SCREEN_RECT ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define CONTENT_HEIGHT (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT - TAB_SAFE_HEIGHT)
#define STANDARD_FRAME CGRectMake(0, 0, SCREEN_WIDTH, CONTENT_HEIGHT)

#define SCREEN_WIDTH_IPHONE_SCALE SCREEN_WIDTH/375
#define SCREEN_HEIGHT_IPHONE_SCALE SCREEN_HEIGHT/667

#define TEXTSIZE CGSizeMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT - TAB_SAFE_HEIGHT * 2 - 20)

#define MAKESURE(str) [FLAlertTool makeSureValue:str]
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//真机log输出
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n",__TIME__ ,__FUNCTION__ ,__LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)

#endif /* DimensMacros_h */

