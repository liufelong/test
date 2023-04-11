//
//  FLBookDetailController.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/11.
//

#import "FLBookDetailController.h"

@interface FLBookDetailController ()

/*!<#备注#>*/
@property (strong, nonatomic) UITableView *tableView;
/*!table数据源*/
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation FLBookDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}


@end
