//
//  FLBookCollectionCell_rf.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/2.
//

#import "FLBookCollectionCell_rf.h"
#import <UIImageView+WebCache.h>

@implementation FLBookCollectionCell_rf

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(FLBookModel *)model{
    _model = model;
    
    [self.coverimg sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed:@"coverDefault"]];
    self.bookName.text = model.bookname;
    self.adviceCount.text = model.advicecount;
    self.preface.text = model.introduction;
}

@end
