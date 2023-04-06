//
//  FLReadDetailController.h
//  BookRead
//
//  Created by 刘飞龙 on 2023/3/20.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLReadDetailController : BaseViewController

@property (nonatomic, assign) NSUInteger itemIndex;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *pageLabel;
@property (strong, nonatomic) IBOutlet UILabel *chapterTitleLabel;

/*!当前章节模型*/
@property (strong, nonatomic) FLChapterModel *chapterModel;
/*!<#备注#>*/
@property (copy, nonatomic) VoidBlock menuBlock;

@end

NS_ASSUME_NONNULL_END
