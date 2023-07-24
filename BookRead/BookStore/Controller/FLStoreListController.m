//
//  FLStoreListController.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/7.
//

#import "FLStoreListController.h"

#import "FLBannerView.h"
#import "FLStoreTableHeaderView.h"
#import "FLCollectionTableCell.h"
#import "FLBookTableCell.h"
#import "FLBookMenuView.h"

#import "FLStoreDataModel.h"
#import "FLStoreRequest.h"

@interface FLStoreListController ()<UITableViewDelegate,UITableViewDataSource>

/*!<#备注#>*/
@property (strong, nonatomic) UITableView *tableView;
/*!table数据源*/
@property (strong, nonatomic) NSMutableArray *dataArr;
/*!banner图数据源*/
@property (strong, nonatomic) NSMutableArray *bannerDataArr;
/*!分类数据源*/
@property (strong, nonatomic) NSMutableArray *classDataArr;

/*!<#备注#>*/
@property (strong, nonatomic) FLBannerView *bannerView;

/*!<#备注#>*/
@property (strong, nonatomic) UIView *headerView;


@end

@implementation FLStoreListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArr = @[].mutableCopy;
    self.bannerDataArr = @[].mutableCopy;
    
    [self createUI];
    
    [self requestData];
}

- (void)createUI {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    CGFloat height = SCREEN_WIDTH * 0.618;
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    self.bannerView = [[FLBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) scrollDuration:5];
    [self.headerView addSubview:self.bannerView];
    
    WS(weakSelf);
    [self.bannerView setBannerDidClicked:^(NSInteger index) {
        [weakSelf bannerClickWithIndex:index];
    }];

    self.tableView.tableHeaderView = self.headerView;
}

//创建分类视图
- (void)createClassView {
    if (self.classDataArr.count == 0) {
        return;
    }
    
    CGFloat height = SCREEN_WIDTH * 0.618 ;
    FLBookMenuView *menuView = [[FLBookMenuView alloc] initWithDataArr:self.classDataArr];
    menuView.frame = CGRectMake(0, height, SCREEN_WIDTH, 80);
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height + 80);
    [self.headerView addSubview:menuView];
    
}

- (void)bannerViewShowImage {
    NSMutableArray *imgArr = @[].mutableCopy;
    for (NSDictionary *dict in self.bannerDataArr) {
        NSString *image_url = dict[@"image_url"];
        [imgArr addObject:image_url];
    }
    self.bannerView.images = imgArr;
}

- (void)requestData {
    
    WS(weakSelf);
    [FLStoreRequest requestStoreInfoWithBody:@{} andSuccess:^(id  _Nonnull result) {
        weakSelf.bannerDataArr = result[@"banner"];
        
        weakSelf.classDataArr = result[@"bookclass"];
        
        NSMutableArray *menulist = result[@"menulist"];
        
        for (NSDictionary *dict in menulist) {
            FLStoreDataModel *model = [[FLStoreDataModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            NSArray *booklist = dict[@"booklist"];
            [model createBookList:booklist];
            [model calculateCellHight];
            [weakSelf.dataArr addObject:model];
        }
        
        [weakSelf bannerViewShowImage];
        
        [weakSelf createClassView];
        
        [weakSelf.tableView reloadData];
    } andFailure:^(NSString * _Nonnull errorType) {
        [FLAlertTool alertWithTitle:@"提示" message:errorType];
    }];
    
}

- (void)tableSelectBook:(FLBookModel *)bookmodel {
    if (self.selectBook) {
        self.selectBook(bookmodel);
    }
}

- (void)bannerClickWithIndex:(NSInteger)index {
    
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
    if ([model.stype isEqualToString:@"1"]) {
        FLBookTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FLBookTableCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"FLBookTableCell" owner:nil options:nil][0];
        }
        FLBookModel *bookmodel = model.booklist[indexPath.row];
        cell.model = bookmodel;
        return cell;
    }else {
        FLCollectionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FLCollectionTableCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"FLCollectionTableCell" owner:nil options:nil][0];
        }
        WS(weakSelf);
        [cell setCellSelectBlock:^(FLBookModel * _Nonnull bookmodel) {
            [weakSelf tableSelectBook:bookmodel];
        }];
        cell.model = model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FLStoreDataModel *model = self.dataArr[indexPath.section];
    if (![model.stype isEqualToString:@"1"]) {
        return;
    }
    FLBookModel *bookmodel = model.booklist[indexPath.row];
    [self tableSelectBook:bookmodel];
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
