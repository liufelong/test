//
//  FLMenuView.h
//  BookRead
//
//  Created by 刘飞龙 on 2022/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    DefaultAction,
    BeforeChapter,
    NextChapter,
    CatalogAction,
    TypeChange,
    SetAction,
    DonwloadAction,
    FontReduce,
    FontAdd,
} MenuBtnTag;

typedef void(^BtnBlock)(MenuBtnTag tag);

@interface FLMenuView : UIView

@property (weak, nonatomic) IBOutlet UIButton *beforeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIButton *calogBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UILabel *fontSizeLabel;



/*!<#备注#>*/
@property (strong, nonatomic) NSMutableArray *bgBtnArr;

/*!<#备注#>*/
@property (copy, nonatomic) BtnBlock btnBlock;

@end

NS_ASSUME_NONNULL_END
