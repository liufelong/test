//
//  FLSegmentedBar.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/7.
//

#import "FLSegmentedBar.h"

@interface FLSegmentedBarItem : UIControl

@property (nonatomic, assign) CGFloat ctnWidth;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *normalText;
@property (nonatomic, copy) NSString *selectText;

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;

- (void)setTitle:(nullable NSString *)title forState:(UIControlState)state;
- (void)setTitleColor:(nullable UIColor *)color forState:(UIControlState)state;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *customeView;

@end

@implementation FLSegmentedBarItem

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.text = self.selected ? (self.selectText ?: self.normalText) : self.normalText;
    self.titleLabel.textColor = self.selected ? (self.selectColor ?: self.normalColor) : self.normalColor;
    
    self.titleLabel.frame = self.bounds;
    [self.titleLabel sizeToFit];
    
    
    self.titleLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.bounds)/2);
    self.ctnWidth = CGRectGetWidth(self.titleLabel.bounds);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    if (state == UIControlStateSelected) {
        self.selectText = title;
    }
    else {
        self.normalText = title;
    }
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    if (state == UIControlStateSelected) {
        self.selectColor = color;
    }
    else {
        self.normalColor = color;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self setNeedsLayout];
}

- (NSString *)title {
    return self.selected ? (self.selectText ?: self.normalText) : self.normalText;
}

- (void)sizeToFit {
    [super sizeToFit];
    
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.frame));
}

@end


@interface FLSegmentedBar ()
@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) FLSegmentedBarItem *lastSelectItem;
@property (nonatomic, strong) NSMutableArray *itemsArr;

@property (nonatomic, strong) UIView *scrollIndicator;

@end

@implementation FLSegmentedBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _indicatorWidth = 20.f;
        _itemWidth = 75.f;
        _autoItemWidth = NO;
        _itemsArr = [[NSMutableArray alloc] initWithCapacity:2];

        
        _bgScrollView = [[UIScrollView alloc] init];
        [self addSubview:_bgScrollView];
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        
        
        _scrollIndicator = [[UIView alloc] init];
        [self.bgScrollView addSubview:_scrollIndicator];
        _scrollIndicator.frame = CGRectMake(0, 0, _indicatorWidth, 2);
        _scrollIndicator.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat boundWidth = CGRectGetWidth(self.bounds);
    _bgScrollView.frame = self.bounds;
    
    CGFloat ctnWidth = 0.f;
    CGFloat itemWidth = _itemWidth;
    CGSize textSize = CGSizeMake(MAXFLOAT, CGRectGetHeight(self.bounds)-2);
    NSDictionary *font = @{NSFontAttributeName:CustomFont(16.f)};
    for (FLSegmentedBarItem *item in self.itemsArr) {
        if (_autoItemWidth) {
            CGRect rect = [item.title boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:font context:nil];
            itemWidth = ceil(CGRectGetWidth(rect))+20.f;
        } else {
            if ((boundWidth / _itemsArr.count) > itemWidth) {
                itemWidth = boundWidth / _titleItems.count;
            }
        }
        
        item.frame = CGRectMake(ctnWidth, 0, itemWidth, CGRectGetHeight(self.bounds)-2);
        if (ctnWidth == 0) {
            [item layoutIfNeeded];
            
            _scrollIndicator.frame = CGRectMake(0, 0, _indicatorWidth, 2);
            _scrollIndicator.center = CGPointMake(item.center.x, CGRectGetHeight(self.bounds) - 6);
        }
        
        ctnWidth += itemWidth;
    }
    
    _bgScrollView.contentSize = CGSizeMake(ctnWidth, CGRectGetHeight(self.bounds));
}

- (void)setTitleItems:(NSArray<NSString *> *)titleItems {
    _titleItems = titleItems;
    
    
    if (self.selectColor) {
        _scrollIndicator.backgroundColor = self.selectColor;
    }
    
    for (NSString *title in titleItems) {
        FLSegmentedBarItem *item = [[FLSegmentedBarItem alloc] init];
        [self.bgScrollView addSubview:item];
        if (item) {
            [self.itemsArr addObject:item];
        }
        [item addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
        [item setTitle:title forState:UIControlStateNormal];
        
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [item setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        item.titleLabel.font = CustomFont(14.f);
        
        if (self.normalColor) {
            [item setTitleColor:self.normalColor forState:UIControlStateNormal];
        }
        
        if (self.selectColor) {
            [item setTitleColor:self.selectColor forState:UIControlStateSelected];
        }
        
        if (self.normalFont) {
            item.titleLabel.font = self.normalFont;
        }
        
    }
    [self setSelectdItemAtIndex:0];
}

- (void)setSelectdItemAtIndex:(NSInteger)index {
    if (index < self.itemsArr.count) {
        FLSegmentedBarItem *item = [self.itemsArr objectAtIndex:index];
        
        _lastSelectItem.selected = NO;
        item.selected = YES;
        _lastSelectItem = item;
        
        if (self.normalFont) {
            _lastSelectItem.titleLabel.font = self.normalFont;
        }
        
        if (self.selectFont) {
            item.titleLabel.font = self.selectFont;
        }
        
        [self scrollItemToCenter:item];
        
        WS(weakSelf);
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollIndicator.frame = CGRectMake(0, 0, weakSelf.indicatorWidth, 2);
            self.scrollIndicator.center = CGPointMake(item.center.x, CGRectGetHeight(self.bounds) - 6);
        }];
    }
}
/// 设置选中的标题居中
- (void)scrollItemToCenter:(UIView *)item {
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.bgScrollView.contentSize.width - CGRectGetWidth(self.bounds);
    if (maxOffsetX > 0) {
        // 计算偏移量
        CGFloat offsetX = item.center.x - CGRectGetWidth(self.bounds) * 0.5;
        if (offsetX < 0) offsetX = 0;
        
        // 偏移量 > 最大滚动范围，将偏移量设置为最懂滚动范围
        if (offsetX > maxOffsetX) offsetX = maxOffsetX;
        
        // 滚动标题滚动条
        [self.bgScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}

#pragma mark - Actions
- (void)itemSelected:(FLSegmentedBarItem *)aControl {
    if (!aControl.selected) {
        NSInteger index = [self.itemsArr indexOfObject:aControl];
        [self setSelectdItemAtIndex:index];
        
        if (self.didSelectedItemAtIndex) {
            self.didSelectedItemAtIndex(index);
        }
    }
}

@end
