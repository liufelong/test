//
//  FLBookCollectionCell.m
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/17.
//

#import "FLBookCollectionCell.h"
#import <UIImageView+WebCache.h>

@implementation FLBookCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(FLBookModel *)model{
    _model = model;
    
    [self.coverimg sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed:@"coverDefault"]];
    self.bookName.text = model.bookname;
    self.authorName.text = model.authorname;
    
}

@end
