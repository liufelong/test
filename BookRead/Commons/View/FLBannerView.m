//
//  FLBannerView.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/2.
//

#import "FLBannerView.h"
#import <UIImageView+WebCache.h>

@interface FLBannerView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, assign) NSInteger curIndex;
/** scroll timer */
@property (nonatomic, strong) NSTimer *scrollTimer;
/** scroll duration */
@property (nonatomic, assign) NSTimeInterval scrollDuration;

@end

@implementation FLBannerView

- (instancetype)initWithFrame:(CGRect)frame scrollDuration:(NSTimeInterval)duration
{
    if (self = [super initWithFrame:frame]) {
        self.scrollDuration = 0.f;
        [self addObservers];
        [self setupViews];
        if (duration > 0.f) {
            self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:(self.scrollDuration = duration)
                                                                target:self
                                                              selector:@selector(scrollTimerDidFired:)
                                                              userInfo:nil
                                                               repeats:YES];
            [self.scrollTimer setFireDate:[NSDate distantFuture]];
        }
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.scrollDuration = 0.f;
        [self addObservers];
        [self setupViews];
    }
    
    return self;
}

- (void)dealloc {
    [self removeObservers];
    
    if (self.scrollTimer) {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

#pragma mark - setupViews
- (void)setupViews {
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.middleImageView];
    [self.scrollView addSubview:self.rightImageView];
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
    [self placeSubviews];
}

- (void)placeSubviews {
    self.scrollView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.bounds) - 30.f, CGRectGetWidth(self.bounds), 20.f);
    
    CGFloat imageWidth = CGRectGetWidth(self.scrollView.bounds);
    CGFloat imageHeight = CGRectGetHeight(self.scrollView.bounds);
    self.leftImageView.frame    = CGRectMake(imageWidth * 0, 0, imageWidth, imageHeight);
    self.middleImageView.frame  = CGRectMake(imageWidth * 1, 0, imageWidth, imageHeight);
    self.rightImageView.frame   = CGRectMake(imageWidth * 2, 0, imageWidth, imageHeight);
    self.scrollView.contentSize = CGSizeMake(imageWidth * 3, 0);
    
    [self setScrollViewContentOffsetCenter];
}

#pragma mark - 把scrollView偏移到中心位置
- (void)setScrollViewContentOffsetCenter {
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0);
}

#pragma mark - kvo
- (void)addObservers {
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self caculateCurIndex];
    }
}

#pragma mark - getters
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    
    return _pageControl;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
    }
    
    return _leftImageView;
}

- (UIImageView *)middleImageView {
    if (!_middleImageView) {
        _middleImageView = [UIImageView new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
        [_middleImageView addGestureRecognizer:tap];
        _middleImageView.userInteractionEnabled = YES;
    }
    
    return _middleImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
    }
    
    return _rightImageView;
}


#pragma mark - setters
- (void)setImages:(NSArray *)images {
    if (images) {
        _images = images;
        self.curIndex = 0;
        
        if (images.count > 1) {
            // auto scroll
            [self.scrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.scrollDuration]];
            self.pageControl.numberOfPages = images.count;
            self.pageControl.currentPage = 0;
            self.pageControl.hidden = NO;
        } else {
            self.pageControl.hidden = YES;
            [self.leftImageView removeFromSuperview];
            [self.rightImageView removeFromSuperview];
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), 0);
        }
    }
}

- (void)setCurIndex:(NSInteger)curIndex {
    if (_curIndex >= 0) {
        _curIndex = curIndex;
        
        // caculate index
        NSInteger imageCount = self.images.count;
        NSInteger leftIndex = (curIndex + imageCount - 1) % imageCount;
        NSInteger rightIndex= (curIndex + 1) % imageCount;
        
        // image path
        NSString *leftImage = self.images[leftIndex];
        NSString *middleImage = self.images[curIndex];
        NSString *rightImage = self.images[rightIndex];

        
        if (_localImgState) {
            self.leftImageView.image = [UIImage imageNamed:leftImage];
            self.middleImageView.image = [UIImage imageNamed:middleImage];
            self.rightImageView.image = [UIImage imageNamed:rightImage];
        } else {
            [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:leftImage] placeholderImage:self.placeHolder];
            [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:middleImage] placeholderImage:self.placeHolder];
            [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:rightImage] placeholderImage:self.placeHolder];
        }

        // 每次滚动后，都需要将当前页移动到中间位置
        [self setScrollViewContentOffsetCenter];
        
        self.pageControl.currentPage = curIndex;
    }
}

- (void)checkElementOfImages:(NSArray *)images
{
    for (id obj in images) {
        if (![obj isKindOfClass:[NSString class]]) {
            NSException *e = [NSException exceptionWithName:@"PathVailed" reason:@"必须为图片名、图片本地路径或是图片地址" userInfo:nil];
            @throw e;
        }
    }
}

#pragma mark - caculate curIndex
- (void)caculateCurIndex {
    if (self.images && self.images.count > 0) {
        CGFloat pointX = self.scrollView.contentOffset.x;
        
        // 临界值判断，第一个和第三个imageView的contentoffset
        CGFloat criticalValue = .2f;
        
        // 向右滑动，右侧临界值的判断
        if (pointX > 2 * CGRectGetWidth(self.scrollView.bounds) - criticalValue) {
            self.curIndex = (self.curIndex + 1) % self.images.count;
        } else if (pointX < criticalValue) {// 向左滑动，左侧临界值的判断
            self.curIndex = (self.curIndex + self.images.count - 1) % self.images.count;
        }
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.images.count > 1) {
        [self.scrollTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.images.count > 1) {
        [self.scrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.scrollDuration]];
    }
}

#pragma mark - button actions
- (void)imageClicked:(UITapGestureRecognizer *)tap {
    if (self.bannerDidClicked) {
        self.bannerDidClicked(self.curIndex);
    }
}

#pragma mark - timer action
- (void)scrollTimerDidFired:(NSTimer *)timer {
    // 矫正imageView的frame：因为定时器的自动滚动，可能导致轮播图一页显示两张图片的情况
    CGFloat criticalValue = .2f;
    if (self.scrollView.contentOffset.x < CGRectGetWidth(self.scrollView.bounds) - criticalValue || self.scrollView.contentOffset.x > CGRectGetWidth(self.scrollView.bounds) + criticalValue) {
        [self setScrollViewContentOffsetCenter];
    }
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.bounds), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}





@end
