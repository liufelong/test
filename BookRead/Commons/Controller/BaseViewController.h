//
//  BaseViewController.h
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (strong, nonatomic) UILabel * titleLabel;     /*导航栏标题*/
@property (strong, nonatomic) UIButton *leftButton;     /*左侧按钮*/
@property (strong, nonatomic) UIButton *rightButton;    /*右侧按钮*/


- (void)changeNavStyle;

- (void)navbanckBtnClick;

@end

NS_ASSUME_NONNULL_END
