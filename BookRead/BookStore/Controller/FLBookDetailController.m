//
//  FLBookDetailController.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/11.
//

#import "FLBookDetailController.h"

#import "FLDetailHeaderView.h"

@interface FLBookDetailController ()

/*!<#备注#>*/
@property (strong, nonatomic) UITableView *tableView;
/*!table数据源*/
@property (strong, nonatomic) NSMutableArray *dataArr;

/*!<#备注#>*/
@property (strong, nonatomic) FLDetailHeaderView *headerView;

@end

@implementation FLBookDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.headerView = [[FLDetailHeaderView alloc] init];
    CGFloat height = 130/*图片高度*/ + 37/*缝隙*/ + 40/*文字*/;
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    self.headerView.model = self.model;
    WS(weakSelf);
    self.headerView.heightBlock = ^(BOOL value) {
        [weakSelf headerViewUpdataFrame:value];
    };
    [self.view addSubview:self.headerView];
    
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.equalTo(self.view);
//    }];
}

- (void)headerViewUpdataFrame:(BOOL)state {
    CGFloat height = 130/*图片高度*/ + 37/*缝隙*/ + 40/*文字*/;
    if (state) {
        CGFloat hight = [self.model.introduction compressedSizeInLabelWithWidth:SCREEN_WIDTH - 60 fontSize:14];
        if (hight < 40) {
            hight = 40;
        }
        height = 130/*图片高度*/ + 37/*缝隙*/ + hight;
    }
    
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
}

@end
