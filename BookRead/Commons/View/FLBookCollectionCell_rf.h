//
//  FLBookCollectionCell_rf.h
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/2.
//  左右结构的书籍cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLBookCollectionCell_rf : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverimg;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *preface;
@property (weak, nonatomic) IBOutlet UILabel *adviceCount;

@property (strong, nonatomic) FLBookModel *model;
@end

NS_ASSUME_NONNULL_END
