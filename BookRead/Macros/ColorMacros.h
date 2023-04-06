//
//  ColorMacros.h
//  aasipods
//
//  Created by zxyuan on 16/3/18.
//  Copyright © 2016年 zxyuan. All rights reserved.
//

#ifndef ColorMacros_h
#define ColorMacros_h

#define R_G_B_16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
#define R_G_B_A_16(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:a]

 //财险
#define CX_THEME_COLOR R_G_B_16(0XFB5B5C)  //财险主题色
#define CX_MAIN_COLOR R_G_B_16(0XFE5958) //与CX_THEME_COLOR基本一致
#define CX_PROMINENT_COLOR R_G_B_16(0XFF0D00) //财险提示信息颜色
#define CX_BACKGROUND_COLOR R_G_B_16(0XEEF0F4) //财险默认背景色
#define CX_MODULAR_SPLIT_COLOR R_G_B_16(0XEAEAEA) //财险模块之间分割背景色
#define CX_LINK_COLOR R_G_B_16(0X42A4FF) //财险可点击链接颜色
#define CX_WORNING_COLOR R_G_B_16(0XFFAF2B) //财险⚠️、购物车、暂存新增等
#define CX_COLOR_333 R_G_B_16(0X333333) //财险主标题颜色,用于重要级文字信息、内页标题信息
#define CX_COLOR_666 R_G_B_16(0X666666) //财险二级文字信息, 用于普通级段落信息
#define CX_COLOR_999 R_G_B_16(0X999999) //财险用于辅助说明文字信息
#define CX_COLOR_CCC R_G_B_16(0XCCCCCC) //textField(textView)占位符颜色
#define CX_COLOR_DDD R_G_B_16(0XDDDDDD) //borderColor颜色
#define CX_COLOR_EEE R_G_B_16(0XEEEEEE)
#define CX_COLOR_FFF R_G_B_16(0XFFFFFF) //内容区域背景底色
#define CX_COLOR_333_(a) R_G_B_A_16(0X333333,a)
#define CX_COLOR_666_(a) R_G_B_A_16(0X666666,a)
#define CX_COLOR_999_(a) R_G_B_A_16(0X999999,a)

//集团E通3.0改版
#define JT_THEME_COLOR R_G_B_16(0XFF3333)  //集团主题色
#define JT_GRADUAL_COLOR R_G_B_16(0XFF5D36) //集团主题色 渐变颜色
#define JT_MAIN_TEXT_COLOR R_G_B_16(0X1A1A1A) //集团主标题颜色, 用于重要级文字信息、内页标题信息
#define JT_SECONDARY_TEXT_COLOR R_G_B_16(0X3C435A) //集团二级文字信息, 用于普通级段落信息
#define JT_DESCRIPTION_TEXT_COLOR R_G_B_16(0X757F8F) //集团用于辅助说明文字信息
#define JT_MODULAR_SPLIT_COLOR R_G_B_16(0XF3F6FA) //集团模块之间分割背景色


//通用
#define LINE_COLOR R_G_B_16(0XE6E6E6)//边框颜色
#define BUTTON_BACKGROUND_COLOR R_G_B_16(0XE8390E) //按钮红背景色
#define BUTTON_BACKGROUND_CANCEL_COLOR R_G_B_16(0XBEBFC1) //按钮灰背景色
#define TABLEVIEW_HEADER_FOOTER_COLOR R_G_B_16(0XF2F2F2) //tableView表头表尾颜色
#define GAPLINE_COLOR R_G_B_16(0XEBEBEB) //分隔线颜色

#endif /* ColorMacros_h */
