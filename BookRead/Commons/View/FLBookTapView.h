//
//  FLBookTapView.h
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLBookTapView : UIView

/*!<#备注#>*/
@property (strong, nonatomic) UILabel *tapNameLb;

/*!<#备注#>*/
@property (strong, nonatomic) FLTapModel *tapModel;

@end

NS_ASSUME_NONNULL_END
