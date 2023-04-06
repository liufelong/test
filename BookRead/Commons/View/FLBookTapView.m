//
//  FLBookTapView.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/2.
//

#import "FLBookTapView.h"

@implementation FLBookTapView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.tapNameLb = [[UILabel alloc] init];
    self.tapNameLb.font = [UIFont systemFontOfSize:12];
    self.tapNameLb.textColor = CX_COLOR_666;
    
    self.tapNameLb.layer.masksToBounds = YES;
    self.tapNameLb.layer.cornerRadius = 2;
    self.tapNameLb.layer.borderWidth = 1;
    self.tapNameLb.layer.borderColor = CX_COLOR_666.CGColor;
    
    [self addSubview:self.tapNameLb];
    [self.tapNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(1, 5, 1, 5));
    }];
}

- (void)setTapModel:(FLTapModel *)tapModel {
    _tapModel = tapModel;
    
    self.tapNameLb.text = tapModel.tapname;
    if (tapModel.colorstring.length > 0) {
        self.tapNameLb.layer.borderColor = tapModel.colorUi.CGColor;
        self.tapNameLb.textColor = tapModel.colorUi;
    }
}

@end
