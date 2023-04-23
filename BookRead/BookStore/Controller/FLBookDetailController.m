//
//  FLBookDetailController.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/11.
//

#import "FLBookDetailController.h"

#import "FLDetailHeaderView.h"
#import "FLStoreTableHeaderView.h"
#import "FLCollectionTableCell.h"

#import "FLStoreRequest.h"

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
    
    self.titleLabel.text = self.model.bookname;
    
    self.headerView = [[FLDetailHeaderView alloc] init];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 170);
    self.headerView.model = self.model;
        
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    self.tableView.tableHeaderView = self.headerView;
    
    [self requestShowData];
}

- (void)requestShowData {
    
    WS(weakSelf);
    [FLStoreRequest requestBookDetailWithBody:@{} andSuccess:^(id  _Nonnull result) {
        [weakSelf createShowDataWith:result];
    } andFailure:^(NSString * _Nonnull errorType) {
        [FLAlertTool alertWithTitle:@"提示" message:errorType];
    }];
}

- (void)createShowDataWith:(NSMutableDictionary *)dict {
    
}

#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FLStoreDataModel *model = self.dataArr[section];
    if ([model.stype isEqualToString:@"1"]) {
        return model.booklist.count;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FLStoreDataModel *model = self.dataArr[indexPath.section];
    
    
    FLCollectionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FLCollectionTableCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FLCollectionTableCell" owner:nil options:nil][0];
    }
    WS(weakSelf);
    [cell setCellSelectBlock:^(FLBookModel * _Nonnull bookmodel) {
//            [weakSelf tableSelectBook:bookmodel];
    }];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FLStoreTableHeaderView *header = [FLStoreTableHeaderView groupHeaderWithTableView:tableView];
    FLStoreDataModel *model = self.dataArr[section];
    header.titleLabel.text = model.title;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FLStoreDataModel *model = self.dataArr[indexPath.section];
    return model.cellHight;
}

@end
