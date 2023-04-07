//
//  FLStoreListController.h
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/7.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLStoreListController : BaseViewController

/*!类型*/
@property (copy, nonatomic) NSString *type;

/*!<#备注#>*/
@property (copy, nonatomic) void(^selectBook)(FLBookModel *book);

@end

NS_ASSUME_NONNULL_END
