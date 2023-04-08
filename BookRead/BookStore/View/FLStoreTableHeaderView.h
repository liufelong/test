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

+ (instancetype)groupHeaderWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
