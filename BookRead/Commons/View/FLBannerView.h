//
//  FLBannerView.h
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/2.
//  轮播图控件

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLBannerView : UIView

/// 指示器
@property (nonatomic, strong) UIPageControl *pageControl;

/// 占位图
@property (strong, nonatomic) UIImage *placeHolder;

/// 是否使用本地图片，默认为 NO
/// 设置为 YES 时，通过 -imageNamed 加载图片
/// 设置为 NO 时，通过 SDWebImage -sd_setImageWithURL: 加载图片
@property (assign, nonatomic) BOOL localImgState;
/// 图片数据源，支持 本地图片名称 和 图片 URL 字符串
@property (nonatomic, copy) NSArray<NSString *> *images;


/// Banner 点击事件
@property (nonatomic, copy) void (^bannerDidClicked) (NSInteger index);


/// 初始化
/// @param frame 坐标
/// @param duration 动画时长
- (instancetype)initWithFrame:(CGRect)frame scrollDuration:(NSTimeInterval)duration;


@end

NS_ASSUME_NONNULL_END
