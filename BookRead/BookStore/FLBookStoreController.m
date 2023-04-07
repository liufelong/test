//
//  FLBookStoreController.m
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/25.
//

#import "FLBookStoreController.h"
#import "FLSegmentedBar.h"

@interface FLBookStoreController ()

@property (nonatomic, strong) FLSegmentedBar *segmentedBar;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classcodes;
@property (nonatomic, strong) NSMutableArray *containerArr;

@end

@implementation FLBookStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[@"意外健康险",@"责任险",@"家财险", @"货运险" ,@"保证险",@"组合险", @"企财险" , @"航空险", @"个人非车险",@"工程险"].mutableCopy;
    self.classcodes = @[@"06" ,@"10", @"02", @"09" ,@"12",@"21", @"01", @"16",@"29",@"03" ].mutableCopy;
    
    self.containerArr = @[].mutableCopy;
    
    [self setupSubviews];
}

- (void)setupSubviews {
    self.segmentedBar = [[FLSegmentedBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 40)];
    self.segmentedBar.selectColor = [UIColor whiteColor];
    self.segmentedBar.normalColor = [UIColor blackColor];
    self.segmentedBar.selectFont = CustomFont(15);
    self.segmentedBar.normalFont = CustomFont(14);
    self.segmentedBar.titleItems = self.titles;
    self.segmentedBar.autoItemWidth = YES;
   
//    [self.view addSubview:self.segmentedBar];
    
    self.navigationItem.titleView = self.segmentedBar;
    
    WS(weakSelf);
    [self.segmentedBar setDidSelectedItemAtIndex:^(NSInteger index) {
//        [weakSelf showVc:index];
    }];
}

@end
