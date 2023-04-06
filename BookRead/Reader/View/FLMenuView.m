//
//  FLMenuView.m
//  BookRead
//
//  Created by 刘飞龙 on 2022/10/9.
//

#import "FLMenuView.h"

@interface FLMenuView ()

@property (weak, nonatomic) IBOutlet UIButton *bgBtn1;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn2;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn3;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn4;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn5;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn6;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn7;


@end

@implementation FLMenuView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgBtnArr = @[_bgBtn1,_bgBtn2,_bgBtn3,_bgBtn4,_bgBtn5,_bgBtn6,_bgBtn7].mutableCopy;
    for (UIButton *btn in self.bgBtnArr) {
        btn.selected = NO;
        if ([FLUSER.bgName isEqualToString:[btn currentTitle]]) {
            btn.selected = YES;
        }
    }
    
    self.fontSizeLabel.text = FLUSER.fontSize;
}

- (IBAction)buttonAction:(UIButton *)sender {
    if (sender.tag == TypeChange) {
        sender.selected = !sender.selected;
        FLUSER.isNight = sender.selected;
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeReadType object:nil];
    }else if (sender.tag == FontReduce || sender.tag == FontAdd) {
        if (sender.tag == FontReduce) {
            FLUSER.fontSize = [NSString stringWithFormat:@"%d",FLUSER.fontSize.intValue - 1];
        }else {
            FLUSER.fontSize = [NSString stringWithFormat:@"%d",FLUSER.fontSize.intValue + 1];
        }
        self.fontSizeLabel.text = FLUSER.fontSize;
    }
    
    if (self.btnBlock) {
        self.btnBlock(sender.tag);
    }
}

- (IBAction)bgButtonAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    for (UIButton *btn in self.bgBtnArr) {
        btn.selected = NO;
    }
    
    sender.selected = YES;
    //背景颜色
    FLUSER.bgName = [sender currentTitle];
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeReadType object:nil];
}

@end
