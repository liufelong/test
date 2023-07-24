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
    self.tapNameLb.textColor = CX_COLOR_999;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2;
    self.layer.borderWidth = 1;
    self.layer.borderColor = CX_COLOR_999.CGColor;
    
    [self addSubview:self.tapNameLb];
    [self.tapNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(1, 5, 1, 5));
    }];
}

- (void)setTapModel:(FLTapModel *)tapModel {
    _tapModel = tapModel;
    
    self.tapNameLb.text = tapModel.tapname;
    if (tapModel.colorstring.length > 0) {
        self.layer.borderColor = tapModel.colorUi.CGColor;
        self.tapNameLb.textColor = tapModel.colorUi;
    }else {
        self.layer.borderColor = CX_COLOR_999.CGColor;
        self.tapNameLb.textColor = CX_COLOR_999;
    }
}

@end
