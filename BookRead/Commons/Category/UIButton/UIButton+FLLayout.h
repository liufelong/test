//
//  UIButton+Layout.h
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ButtonImgPositon) {
    ButtonImgLeft,   ///< 图片在左侧
    ButtonImgRight,  ///< 图片在右侧
    ButtonImgTop,    ///< 图片在上侧
    ButtonImgBottom, ///< 图片在下侧
};

@interface UIButton (FLLayout)

/// 更新按钮图片和文字的排列方式
/// @param imgPosition 排列方式枚举
- (void)layoutImage:(ButtonImgPositon)imgPosition;

@end

NS_ASSUME_NONNULL_END
