//
//  FLBookShelfCollectionCell.h
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/8.
//

#import <UIKit/UIKit.h>
#import "FLBookModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FLBookShelfCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverimg;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *authorName;

@property (weak, nonatomic) IBOutlet UIImageView *selectImg;

/*!<#备注#>*/
@property (strong, nonatomic) FLBookModel *model;

@end

NS_ASSUME_NONNULL_END
