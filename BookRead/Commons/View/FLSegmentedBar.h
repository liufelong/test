//
//  FLSegmentedBar.h
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLSegmentedBar : UIView

@property (nonatomic, strong) NSArray<NSString *> *titleItems;
@property (nonatomic, assign) CGFloat indicatorWidth;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) BOOL autoItemWidth;

@property (nonatomic, strong) UIColor *textColor;

//两个状态颜色同时设置才会生效
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIFont *normalFont;

@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIFont *selectFont;


@property (nonatomic, copy) void(^didSelectedItemAtIndex)(NSInteger index);

- (void)setSelectdItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
