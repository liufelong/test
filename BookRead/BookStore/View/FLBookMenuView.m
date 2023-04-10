//
//  FLBookMenuView.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/10.
//

#import "FLBookMenuView.h"
#import "UIButton+FLLayout.h"

@interface FLBookMenuView ()

/*!<#备注#>*/
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation FLBookMenuView

- (instancetype)initWithDataArr:(NSMutableArray *)dataArr {
    self = [super init];
    if (self) {
        [self createUIWithDataArr:dataArr];
    }
    return self;
}

- (void)createUIWithDataArr:(NSMutableArray *)dataArr {
    self.backgroundColor = [UIColor whiteColor];
    self.dataArr = dataArr;
    UIButton *tempBtn;
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary *dict = dataArr[i];
        UIButton *btn = [self createButtonWithDict:dict];
        btn.tag = i + 1;
        if (tempBtn) {
            if (i == dataArr.count) {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self);
                    make.left.equalTo(tempBtn.mas_right).offset(5);
                    make.right.equalTo(self).offset(-12);
                    make.width.equalTo(tempBtn);
                }];
            }else {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self);
                    make.left.equalTo(tempBtn.mas_right).offset(5);
                    make.width.equalTo(tempBtn);
                }];
            }
        }else {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.left.mas_equalTo(12);
            }];
        }
        tempBtn = btn;
    }
}

- (UIButton *)createButtonWithDict:(NSDictionary *)dict {
    
    NSString *title = dict[@"title"];
    NSString *imgName = dict[@"iconimage"];
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self addSubview:imgBtn];
    [imgBtn setTitle:title forState:UIControlStateNormal];
    [imgBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [imgBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    imgBtn.titleLabel.font = CustomFont(14);
    [imgBtn setTitleColor:CX_COLOR_333 forState:UIControlStateNormal];
    [imgBtn layoutImage:ButtonImgRight];
    
    return imgBtn;
}

- (void)btnClicked:(UIButton *)btn {
    if (self.clickBlock) {
        NSDictionary *dict = self.dataArr[btn.tag - 1];
        self.clickBlock(dict);
    }
}

@end
