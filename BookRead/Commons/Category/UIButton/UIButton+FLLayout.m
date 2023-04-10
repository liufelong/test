//
//  UIButton+Layout.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/10.
//

#import "UIButton+FLLayout.h"

@implementation UIButton (FLLayout)

- (void)layoutImage:(ButtonImgPositon)imgPosition {
    CGRect imageRect = [self imageRectForContentRect:self.bounds];
    CGRect titleRect = [self titleRectForContentRect:self.bounds];

    switch (imgPosition) {
        case ButtonImgLeft:
            self.imageEdgeInsets = UIEdgeInsetsZero;
            self.titleEdgeInsets = UIEdgeInsetsZero;
            break;
        case ButtonImgRight: {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, CGRectGetWidth(titleRect), 0, -CGRectGetWidth(titleRect));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -CGRectGetWidth(imageRect), 0, CGRectGetWidth(imageRect));
        }
            break;
        case ButtonImgTop: {
           
            self.imageEdgeInsets = UIEdgeInsetsMake(-CGRectGetHeight(imageRect)/2, CGRectGetWidth(titleRect)/2.0, CGRectGetHeight(imageRect)/2, -CGRectGetWidth(titleRect)/2.0);
            self.titleEdgeInsets = UIEdgeInsetsMake(CGRectGetHeight(titleRect)/2, -CGRectGetWidth(imageRect), -CGRectGetHeight(titleRect)/2, 0);

        }
            
            break;
        case ButtonImgBottom: {
            self.imageEdgeInsets = UIEdgeInsetsMake(CGRectGetHeight(imageRect)/2, CGRectGetWidth(titleRect)/2.0, -CGRectGetHeight(imageRect)/2, -CGRectGetWidth(titleRect)/2.0);
            self.titleEdgeInsets = UIEdgeInsetsMake(-CGRectGetHeight(titleRect)/2, -CGRectGetWidth(imageRect), CGRectGetHeight(titleRect)/2, 0);
        }
            
            break;
        default:
            break;
    }
}

@end
