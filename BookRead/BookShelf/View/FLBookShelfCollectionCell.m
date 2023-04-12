//
//  FLBookShelfCollectionCell.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/8.
//

#import "FLBookShelfCollectionCell.h"

@implementation FLBookShelfCollectionCell

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
