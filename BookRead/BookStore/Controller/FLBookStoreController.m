//
//  FLBookStoreController.m
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/25.
//

#import "FLBookStoreController.h"
#import "FLBookDetailController.h"

#import "FLSegmentedBar.h"

#import "FLStoreListController.h"

@interface FLBookStoreController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classcodes;
@property (nonatomic, strong) NSMutableArray *containerArr;

@property (nonatomic, strong) FLSegmentedBar *segmentedBar;
@property (nonatomic, strong) UIScrollView *bgScrollView;

/*!<#备注#>*/
@property (assign, nonatomic) CGFloat hight;

@end

@implementation FLBookStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[@"意外健康险",@"责任险",@"家财险", @"货运险" ,@"保证险",@"组合险", @"企财险" , @"航空险", @"个人非车险",@"工程险"].mutableCopy;
    self.classcodes = @[@"06" ,@"10", @"02", @"09" ,@"12",@"21", @"01", @"16",@"29",@"03" ].mutableCopy;
    
    self.containerArr = @[].mutableCopy;
    
//    self.hight = SCREEN_HEIGHT - 176;

    self.hight = SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_Safe_HEIGHT;
    
    [self setupSubviews];
    
    [self showVc:0];
}

- (void)setupSubviews {
    self.segmentedBar = [[FLSegmentedBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 40)];
    self.segmentedBar.selectColor = [UIColor whiteColor];
    self.segmentedBar.normalColor = [UIColor blackColor];
    self.segmentedBar.selectFont = CustomFont(15);
    self.segmentedBar.normalFont = CustomFont(14);
    self.segmentedBar.titleItems = self.titles;
    self.segmentedBar.autoItemWidth = YES;
       
    self.navigationItem.titleView = self.segmentedBar;
    
    WS(weakSelf);
    [self.segmentedBar setDidSelectedItemAtIndex:^(NSInteger index) {
        [weakSelf showVc:index];
    }];
    
//    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.segmentedBar.frame)-TAB_SAFE_HEIGHT)];

    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.hight)];
    [self.view addSubview:self.bgScrollView];
//    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.view).offset(-TAB_BAR_Safe_HEIGHT);
//    }];
    
    self.bgScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bgScrollView.frame)*self.titles.count, self.hight);
    self.bgScrollView.backgroundColor = [UIColor clearColor];
    self.bgScrollView.pagingEnabled = YES;
    self.bgScrollView.bounces = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.delegate = self;
}

- (void)showVc:(NSInteger)index {
    for (NSInteger i = self.containerArr.count; i <= index; i++) {
        [self.containerArr addObject:[NSNull null]];
    }
    
    CGFloat width = CGRectGetWidth(self.bgScrollView.frame);
    if ([self.containerArr[index] isKindOfClass:[NSNull class]]) {
//        CGFloat height = CGRectGetHeight(self.bgScrollView.frame);
        
        UIViewController *vc = [self scrollContainerViewControllerAtIndex:index];
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        vc.view.frame = CGRectMake(width*index, 0, width, self.hight);
        [self.bgScrollView addSubview:vc.view];
        [self.containerArr replaceObjectAtIndex:index withObject:vc];
    }
    
    [self.bgScrollView setContentOffset:CGPointMake(width*index, 0) animated:YES];
}

- (UIViewController *)scrollContainerViewControllerAtIndex:(NSInteger)index {
    FLStoreListController *list = [[FLStoreListController alloc] init];
    list.type = self.classcodes[index];
    WS(weakSelf)
    list.selectBook = ^(FLBookModel * _Nonnull book) {
        [weakSelf jumbToDetailController:book];
    };
    return list;
}

- (void)jumbToDetailController:(FLBookModel *)bookmodel {
    FLBookDetailController *detailVC = [[FLBookDetailController alloc] init];
    detailVC.model = bookmodel;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self.segmentedBar setSelectdItemAtIndex:index];
    [self showVc:index];
}


@end
