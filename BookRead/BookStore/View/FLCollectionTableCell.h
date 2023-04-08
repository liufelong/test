//
//  FLCollectionTableCell.h
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/7.
//  tableViewcell里面放着collectionView

#import <UIKit/UIKit.h>

#import "FLStoreDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLCollectionTableCell : UITableViewCell

/*!<#备注#>*/
@property (strong, nonatomic) FLStoreDataModel *model;
@property (copy, nonatomic) void(^cellSelectBlock)(FLBookModel *bookmodel);

@end

NS_ASSUME_NONNULL_END
