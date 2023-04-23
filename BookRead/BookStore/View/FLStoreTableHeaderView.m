//
//  FLStoreTableHeaderView.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/7.
//

#import "FLStoreTableHeaderView.h"

@interface FLStoreTableHeaderView ()

@property (strong, nonatomic) UIImageView *statImg;

@end

@implementation FLStoreTableHeaderView

+ (instancetype)groupHeaderWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"FLStoreTableHeaderView";
    FLStoreTableHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!header) {
        header = [[FLStoreTableHeaderView alloc] initWithReuseIdentifier:identifier];
    }
    return header;
}

+ (instancetype)groupDetailHeaderWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"DetailTableHeaderView";
    FLStoreTableHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!header) {
        header = [[FLStoreTableHeaderView alloc] initWithReuseIdentifier:identifier];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        if ([reuseIdentifier isEqualToString:@"DetailTableHeaderView"]) {
            [self createDetailUI];
        }else {
            [self creatUI];
        }
    }
    return self;
}


- (void)creatUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIView *redView = [[UIView alloc] init];
    redView.frame = CGRectMake(15,13,2,18);
    redView.backgroundColor = CX_MAIN_COLOR;
    [self addSubview:redView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 12, 200, 20)];
    self.titleLabel.font = CustomFont(14);
    self.titleLabel.textColor = CX_COLOR_333;
    [self addSubview:self.titleLabel];
    
//    UIView *lin = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
//    lin.backgroundColor = TABLEVIEW_HEADER_FOOTER_COLOR;
//    [self addSubview:lin];
    
}

- (void)createDetailUI {
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = CustomFont(14);
    self.titleLabel.textColor = CX_COLOR_666;
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-40);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    self.statImg = [[UIImageView alloc] init];
    self.statImg.image = [UIImage imageNamed:@"detail_down"];
    [self addSubview:self.statImg];
    [self.statImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(15);
    }];
    
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailBtn addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:detailBtn];
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.bottom.equalTo(self.titleLabel);
    }];
}

- (void)detailAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        self.statImg.image = [UIImage imageNamed:@"detail_up"];
    }else {
        self.statImg.image = [UIImage imageNamed:@"detail_down"];
    }
    
    if (self.heightBlock) {
        self.heightBlock(sender.selected);
    }
    
}

@end
