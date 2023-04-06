//
//  FLBookTableCell.h
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLBookTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverimg;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UITextView *preface;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UIView *tapView;

@property (strong, nonatomic) FLBookModel *model;

@end

NS_ASSUME_NONNULL_END
