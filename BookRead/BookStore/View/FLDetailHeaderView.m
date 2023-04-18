//
//  FLDetailHeaderView.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/11.
//

#import "FLDetailHeaderView.h"

@interface FLDetailHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *coverimg;

@property (weak, nonatomic) IBOutlet UILabel *authornameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordcountLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;


@end

@implementation FLDetailHeaderView

+ (instancetype)detailHeaderView {
    FLDetailHeaderView *header = [[NSBundle mainBundle] loadNibNamed:@"FLDetailHeaderView" owner:nil options:nil][0];
    return header;
}

- (void)setModel:(FLBookModel *)model {
    _model = model;
    
    [self.coverimg sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    self.authornameLabel.text = MAKESURE(model.authorname);
    self.wordcountLabel.text = MAKESURE(model.wordnumber);
    
    NSString *score = [model.score getSignificantFigures];
    self.scoreLabel.text = [NSString stringWithFormat:@"评分:%@分",score];
    
    self.introductionLabel.text = model.introduction;
    
}
- (IBAction)detailAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.heightBlock) {
        self.heightBlock(sender.selected);
    }
}

@end
