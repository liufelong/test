//
//  FLStoreTableHeaderView.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/7.
//

#import "FLStoreTableHeaderView.h"

@implementation FLStoreTableHeaderView

+ (instancetype)groupHeaderWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"FLStoreTableHeaderView";
    FLStoreTableHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!header) {
        header = [[FLStoreTableHeaderView alloc] initWithReuseIdentifier:identifier];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
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

@end
