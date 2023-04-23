//
//  FLStoreTableHeaderView.h
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLStoreTableHeaderView : UITableViewHeaderFooterView

@property (strong, nonatomic) UILabel *titleLabel;

@property (copy, nonatomic) void(^heightBlock)(BOOL state);

+ (instancetype)groupHeaderWithTableView:(UITableView *)tableView;

+ (instancetype)groupDetailHeaderWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
