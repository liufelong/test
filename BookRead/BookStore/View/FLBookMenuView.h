//
//  FLBookMenuView.h
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLBookMenuView : UIView

/*!<#备注#>*/
@property (copy, nonatomic) void(^clickBlock)(NSDictionary *dict);

- (instancetype)initWithDataArr:(NSMutableArray *)dataArr;

@end

NS_ASSUME_NONNULL_END
