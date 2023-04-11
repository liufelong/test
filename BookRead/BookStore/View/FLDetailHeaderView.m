//
//  FLDetailHeaderView.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/11.
//

#import "FLDetailHeaderView.h"

@interface FLDetailHeaderView ()

@property (strong, nonatomic) UIImageView *coverimg;
@property (strong, nonatomic) UILabel *bookName;
@property (strong, nonatomic) UILabel *preface;
@property (strong, nonatomic) UILabel *wordcount;

/*!<#备注#>*/
@property (strong, nonatomic) UIView *starView;

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
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(130);
    }];
    
    self.bookName = [[UILabel alloc] init];
    self.bookName.font = CustomFont(14);
    self.bookName.textColor = CX_COLOR_333;
    [self addSubview:self.bookName];
    [self.bookName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverimg);
        make.left.equalTo(self.coverimg.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
    }];
    
    self.wordcount = [[UILabel alloc] init];
    self.wordcount.font = CustomFont(13);
    self.wordcount.textColor = CX_COLOR_666;
    [self addSubview:self.wordcount];
    [self.wordcount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.coverimg);
        make.left.equalTo(self.coverimg.mas_right).offset(10);
    }];
    
    self.starView = [[UIView alloc] init];
    
    
}

@end
