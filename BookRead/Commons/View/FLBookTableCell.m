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
    self.tapArray = @[].mutableCopy;
    FLBookTapView *tpView;
    for (int i = 1; i < 6; i++) {
        FLBookTapView *temView = [[FLBookTapView alloc] init];
        temView.tag = i;
        [self.tapView addSubview:temView];
        temView.hidden = YES;
        if (tpView) {
            [temView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.tapView);
                make.right.equalTo(tpView.mas_left).offset(-5);
            }];
        }else {
            [temView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.tapView);
                make.right.equalTo(self.tapView);
            }];
        }
        tpView = temView;
        [self.tapArray addObject:temView];
    }
}

- (void)setModel:(FLBookModel *)model{
    _model = model;
    
    [self.coverimg sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed:@"coverDefault"]];
    self.bookName.text = model.bookname;
    self.authorName.text = model.authorname;
    self.preface.text = model.introduction;
    
    [self reloadTapView];
}

- (void)reloadTapView {
    for (FLBookTapView *temView in self.tapArray) {
        temView.hidden = YES;
    }
    for (int i = 0; i < self.model.tapArr.count; i++) {
        FLTapModel *item = self.model.tapArr[i];
        FLBookTapView *temView = self.tapArray[i];
        temView.tapModel = item;
        temView.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
