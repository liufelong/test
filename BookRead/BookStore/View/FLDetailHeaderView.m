//
//  FLDetailHeaderView.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/11.
//

#import "FLDetailHeaderView.h"

@interface FLDetailHeaderView ()

@property (strong, nonatomic) UIImageView *coverimg;

@property (strong, nonatomic) UILabel *authornameLabel;
@property (strong, nonatomic) UILabel *wordcountLabel;

@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UILabel *introductionLabel;

/*!<#备注#>*/
@property (strong, nonatomic) UIImageView *statImg;

@end

@implementation FLDetailHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.coverimg = [[UIImageView alloc] init];
    [self addSubview:self.coverimg];
    [self.coverimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(12);
        make.height.mas_equalTo(130);
        make.width.mas_equalTo(90);
    }];
    
    [self.coverimg setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisVertical];
    [self.coverimg setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisVertical];
    
    self.authornameLabel = [self createLabel];
    [self.authornameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverimg.mas_top);
        make.left.equalTo(self.coverimg.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-12);
    }];
    
    self.wordcountLabel = [self createLabel];
    [self.wordcountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authornameLabel.mas_bottom).offset(15);
        make.left.equalTo(self.coverimg.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-12);
    }];
    
    self.scoreLabel = [self createLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wordcountLabel.mas_bottom).offset(15);
        make.left.equalTo(self.coverimg.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-12);
    }];
    
    UIImageView *iconImg = [[UIImageView alloc] init];
    iconImg.image = [UIImage imageNamed:@"read_icon_vip"];
    [self addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.bottom.equalTo(self.coverimg);
        make.left.equalTo(self.coverimg.mas_right).offset(10);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:R_G_B_16(0XFDA92A) forState:UIControlStateNormal];
    [btn setTitle:@"开通会员，万本小说免费读>" forState:UIControlStateNormal];
    btn.titleLabel.font = CustomFont(12);
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(24);
        make.left.equalTo(self.coverimg.mas_right).offset(20);
        make.centerY.equalTo(iconImg);
    }];
/*
    self.introductionLabel = [self createLabel];
    self.introductionLabel.numberOfLines = 0;
    self.introductionLabel.textColor = CX_COLOR_666;
    [self.introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverimg.mas_bottom).offset(15);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-40);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    self.statImg = [[UIImageView alloc] init];
    self.statImg.image = [UIImage imageNamed:@"detail_down"];
    [self addSubview:self.statImg];
    [self.statImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.introductionLabel);
        make.left.equalTo(self.introductionLabel.mas_right).offset(5);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(15);
    }];
    
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailBtn addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailBtn];
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.bottom.equalTo(self.introductionLabel);

    }];
 */
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    [self addSubview:label];
    label.font = CustomFont(14);
    return label;
}

- (void)setModel:(FLBookModel *)model {
    _model = model;
    
    [self.coverimg sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    self.authornameLabel.text = MAKESURE(model.authorname);
    self.wordcountLabel.text = MAKESURE(model.wordnumber);
    
    NSString *score = [model.score getSignificantFigures];
    self.scoreLabel.text = [NSString stringWithFormat:@"评分:%@分",score];
    
//    self.introductionLabel.text = model.introduction;
    
}
- (void)detailAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    CGFloat height = 40;
    if (sender.selected) {
        self.statImg.image = [UIImage imageNamed:@"detail_up"];
        if (sender.selected) {
            height = [self.model.introduction compressedSizeInLabelWithWidth:SCREEN_WIDTH - 60 fontSize:14];
            if (height < 40) {
                height = 40;
            }
        }
    }else {
        self.statImg.image = [UIImage imageNamed:@"detail_down"];
    }
    
    if (self.heightBlock) {
        self.heightBlock(height);
    }
    
    height = 130 + 37 + height;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    
}

@end
