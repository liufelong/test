//
//  FLReaderController.h
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/17.
//

#import "BaseViewController.h"
#import "FLBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLReaderController : BaseViewController

/*!<#备注#>*/
@property (strong, nonatomic) FLBookModel *bookModel;

/*!<#备注#>*/
@property (assign, nonatomic) NSInteger index;

//加载指定章节
- (void)reloadWithChapter:(FLChapterModel *)model;

@end

NS_ASSUME_NONNULL_END
