//
//  FLCollectionTableCell.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/7.
//

#import "FLCollectionTableCell.h"

#import "FLBookCollectionCell.h"

#import "FLBookCollectionCell_rf.h"

@interface FLCollectionTableCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FLCollectionTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FLBookCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"FLBookCollectionCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FLBookCollectionCell_rf" bundle:nil] forCellWithReuseIdentifier:@"FLBookCollectionCell_rf"];
}

- (void)setModel:(FLStoreDataModel *)model {
    _model = model;
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.model.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.booklist.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.model.stype isEqualToString:@"2"]) {
        FLBookCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FLBookCollectionCell" forIndexPath:indexPath];
        
        FLBookModel *model = self.model.booklist[indexPath.row];
        cell.model = model;
        return cell;
    }else {
        FLBookCollectionCell_rf *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FLBookCollectionCell_rf" forIndexPath:indexPath];
        
        FLBookModel *model = self.model.booklist[indexPath.row];
        cell.model = model;
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    FLBookModel *model = self.dataArr[indexPath.row];
//    if (self.isEdit) {
//        //刷新目标cell
//        model.isSelect = !model.isSelect;
//        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//        return;
//    }
//    FLReaderController *readerController = [[FLReaderController alloc] init];
//    readerController.bookModel = model;
//    readerController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:readerController animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
