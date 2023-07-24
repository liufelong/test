//
//  FLBookShelfController.m
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/17.
//

#import "FLBookShelfController.h"
#import "FLReaderController.h"

#import "FLBookShelfCollectionCell.h"
#import "FLBookModel.h"

@interface FLBookShelfController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/*!<#备注#>*/
@property (strong, nonatomic) NSMutableArray *dataArr;
/*!<#备注#>*/
@property (strong, nonatomic) UICollectionView *collectionView;

/*!<#备注#>*/
@property (assign, nonatomic) BOOL isEdit;

/*!<#备注#>*/
@property (strong, nonatomic) UIView *bottomView;

@end

@implementation FLBookShelfController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArr = FLUSER.bookArray;
    
    [self setUpViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectionReload) name:ReloadBookShelf object:nil];
    
    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(endEdit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)collectionReload {
    
    [FLUSER saveBookArray];
    
    [self.collectionView reloadData];
}

- (void)setUpViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, STATUS_BAR_HEIGHT, SCREEN_WIDTH - 20, CONTENT_HEIGHT) collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FLBookShelfCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"FLBookShelfCollectionCell"];
    [self.collectionView reloadData];
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.collectionView addGestureRecognizer:longPressGes];
    
    [self createBottomView];
}

- (void)createBottomView {
    
    CGFloat height = TAB_BAR_HEIGHT + TAB_SAFE_HEIGHT;
    self.bottomView = [[UIView alloc] init];//WithFrame:CGRectMake(0, SCREEN_HEIGHT - height - STATUS_BAR_HEIGHT, SCREEN_WIDTH, height)
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(height);
    }];
    
    UIButton *allSelectBtn = [[UIButton alloc] init];
    [allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [allSelectBtn setImage:[UIImage imageNamed:@"nm_noselect_red"] forState:UIControlStateNormal];
    [allSelectBtn setImage:[UIImage imageNamed:@"nm_select_red"] forState:UIControlStateSelected];
    [allSelectBtn setTitleColor:CX_COLOR_666 forState:UIControlStateNormal];
    allSelectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [allSelectBtn setBackgroundColor:CX_COLOR_FFF];
    [allSelectBtn addTarget:self action:@selector(allSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    allSelectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);
    allSelectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [self.bottomView addSubview:allSelectBtn];
    
    UIButton *deleteBtn = [[UIButton alloc] init];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:CX_COLOR_FFF forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [deleteBtn setBackgroundColor:CX_MAIN_COLOR];
    [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:deleteBtn];
    
    [allSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bottomView);
        make.height.mas_equalTo(TAB_BAR_HEIGHT);
    }];

    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(allSelectBtn.mas_right);
        make.top.right.equalTo(self.bottomView);
        make.width.equalTo(allSelectBtn.mas_width).multipliedBy(1.5);
        make.height.mas_equalTo(TAB_BAR_HEIGHT);
    }];
    
    self.bottomView.hidden = YES;
}

- (void)allSelectAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    for (FLBookModel *bookModel in self.dataArr) {
        bookModel.isSelect = btn.selected;
    }
    [self.collectionView reloadData];
}

- (void)deleteAction {
    
    NSMutableArray *selectArr = @[].mutableCopy;
    for (FLBookModel *bookModel in self.dataArr) {
        if (bookModel.isSelect) {
            [selectArr addObject:bookModel];
        }
    }
    if (selectArr.count == 0) {
        [FLAlertTool alertWithTitle:@"提示" message:@"请选择要删除的书籍"];
        return;
    }
    
    [FLAlertTool alertWithTitle:@"提示" message:@"是否要删除这些书籍" confirmBlock:^{
        for (FLBookModel *bookModel in selectArr) {
            [FLReaderTool deleteBookWithName:bookModel.bookname];
        }
        [self.dataArr removeObjectsInArray:selectArr];
        [self collectionReload];
    }];
    
}

#pragma mark 长按开始编辑
- (void)longPress:(UILongPressGestureRecognizer *)preGes {
    
    if (preGes.state != UIGestureRecognizerStateBegan) {
        //避免多次响应
        return;
    }
    //开始响应长按按钮
    self.tabBarController.tabBar.hidden = YES;
    self.isEdit = YES;
    [self.collectionView reloadData];
    self.rightButton.hidden = NO;
    self.bottomView.hidden = NO;
}

#pragma mark 结束编辑
- (void)endEdit {
    
    for (FLBookModel *bookModel in self.dataArr) {
        bookModel.isSelect = NO;
    }
    self.tabBarController.tabBar.hidden = NO;
    self.isEdit = NO;
    [self.collectionView reloadData];
    self.rightButton.hidden = YES;
    self.bottomView.hidden = YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 150);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (SCREEN_WIDTH - 320) / 2;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FLBookShelfCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FLBookShelfCollectionCell" forIndexPath:indexPath];
    
    
    FLBookModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    if (self.isEdit) {
        cell.selectImg.hidden = NO;
        if (model.isSelect) {
            cell.selectImg.image = [UIImage imageNamed:@"wagree_select"];
        }else {
            cell.selectImg.image = [UIImage imageNamed:@"icon_selectbox_default"];
        }
    }else {
        cell.selectImg.hidden = YES;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FLBookModel *model = self.dataArr[indexPath.row];
    if (self.isEdit) {
        //刷新目标cell
        model.isSelect = !model.isSelect;
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        return;
    }
    FLReaderController *readerController = [[FLReaderController alloc] init];
    readerController.bookModel = model;
    readerController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:readerController animated:YES];
}

@end
