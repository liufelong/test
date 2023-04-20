//
//  FLDetailHeaderView.h
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLDetailHeaderView : UIView

@property (strong, nonatomic) FLBookModel *model;

/*!<#备注#>*/
@property (copy, nonatomic) void(^heightBlock)(BOOL value);

@end

NS_ASSUME_NONNULL_END
