//
//  FLBookCollectionCell.h
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/17.
//

#import <UIKit/UIKit.h>
#import "FLBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLBookCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverimg;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *authorName;

@property (weak, nonatomic) IBOutlet UIImageView *selectImg;

/*!<#备注#>*/
@property (strong, nonatomic) FLBookModel *model;

@end

NS_ASSUME_NONNULL_END
