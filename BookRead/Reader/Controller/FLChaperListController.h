//
//  FLChaperListController.h
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/30.
//

#import "BaseViewController.h"
#import "FLBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLChaperListController : BaseViewController

/*!<#备注#>*/
@property (strong, nonatomic) FLBookModel *bookModel;

/*!<#备注#>*/
@property (strong, nonatomic) FLChapterModel *chapterModel;

@end

NS_ASSUME_NONNULL_END
