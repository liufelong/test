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

#import "FLStoreDataModel.h"
#import "FLStoreRequest.h"

@interface FLStoreListController ()<UITableViewDelegate,UITableViewDataSource>

/*!<#备注#>*/
@property (strong, nonatomic) UITableView *tableView;
/*!<#备注#>*/
@property (strong, nonatomic) NSMutableArray *dataArr;
/*!<#备注#>*/
@property (strong, nonatomic) NSMutableArray *bannerDataArr;

/*!<#备注#>*/
@property (strong, nonatomic) FLBannerView *bannerView;


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
//    self.bannerView = [[FLBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
//
//    self.tableView.tableHeaderView = self.bannerView;
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
        weakSelf.bannerView = result[@"banner"];
        NSMutableArray *menulist = result[@"menulist"];
        
        for (NSDictionary *dict in menulist) {
            FLStoreDataModel *model = [[FLStoreDataModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            NSArray *booklist = dict[@"booklist"];
            [model createBookList:booklist];
            [model calculateCellHight];
            [weakSelf.dataArr addObject:model];
        }
        
//        [weakSelf bannerViewShowImage];
        
        [weakSelf.tableView reloadData];
    } andFailure:^(NSString * _Nonnull errorType) {
        
    }];
    
}

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
        cell.model = model;
        return cell;
    }
}

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