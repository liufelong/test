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

/*!<#备注#>*/
@property (strong, nonatomic) NSMutableArray *btnArray;

@end

@implementation FLBookMenuView

- (instancetype)initWithDataArr:(NSMutableArray *)dataArr {
    self = [super init];
    if (self) {
        self.dataArr = dataArr;
        self.btnArray = @[].mutableCopy;
        [self createUIWithDataArr:dataArr];
    }
    return self;
}

- (void)createUIWithDataArr:(NSMutableArray *)dataArr {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIButton *tempBtn;
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary *dict = dataArr[i];
        UIButton *btn = [self createButtonWithDict:dict];
        [self.btnArray addObject:btn];
        btn.tag = i + 1;
        if (tempBtn) {
            if (i == dataArr.count - 1) {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self);
                    make.left.equalTo(tempBtn.mas_right).offset(5);
                    make.right.equalTo(self).offset(-12);
                    make.width.equalTo(tempBtn);
                }];
            }else {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self);
                    make.left.equalTo(tempBtn.mas_right).offset(5);
                    make.width.equalTo(tempBtn);
                }];
            }
        }else {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
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
    [imgBtn setTitleColor:CX_COLOR_333 forState:UIControlStateNormal];
    [imgBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [imgBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    imgBtn.titleLabel.font = CustomFont(14);
    
    
    return imgBtn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //按钮刚创建的时候没有frame，所以设置图片在上 没有效果
    for (UIButton *btn in self.btnArray) {
        [btn layoutImage:ButtonImgTop];
    }
}

- (void)btnClicked:(UIButton *)btn {
    if (self.clickBlock) {
        NSDictionary *dict = self.dataArr[btn.tag - 1];
        self.clickBlock(dict);
    }
}

@end
