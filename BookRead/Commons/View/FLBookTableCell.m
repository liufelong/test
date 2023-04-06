//
//  FLBookTableCell.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/2.
//

#import "FLBookTableCell.h"
#import <UIImageView+WebCache.h>
#import "FLBookTapView.h"

@interface FLBookTableCell ()

/*!<#备注#>*/
@property (strong, nonatomic) NSMutableArray *tapArray;

@end

@implementation FLBookTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    FLBookTapView *tapView;
    for (int i = 1; i < 6; i++) {
        FLBookTapView *temView = [[FLBookTapView alloc] init];
        temView.tag = i;
        [self.tapView addSubview:temView];
    }
}

- (void)setModel:(FLBookModel *)model{
    _model = model;
    
    [self.coverimg sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed:@"coverDefault"]];
    self.bookName.text = model.bookname;
    self.authorName.text = model.authorname;
    self.preface.text = model.preface;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
