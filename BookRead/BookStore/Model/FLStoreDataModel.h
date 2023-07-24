//
//  FLStoreDataModel.h
//  BookRead
//
//  Created by 刘飞龙 on 2023/4/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLStoreDataModel : NSObject

/*!<#备注#>*/
@property (copy, nonatomic) NSString *title;
/*!展示样式*/
@property (copy, nonatomic) NSString *stype;
/*!stype 等于 2/3的时候，collection的size*/
@property (assign, nonatomic) CGSize size;
/*!cell高度*/
@property (assign, nonatomic) CGFloat cellHight;
/*!<#备注#>*/
@property (copy, nonatomic) NSString *menuid;
/*!<#备注#>*/
@property (copy, nonatomic) NSString *hasmore;
/*!<#备注#>*/
@property (strong, nonatomic) NSMutableArray *booklist;

- (void)createBookList:(NSArray *)booklist;
- (void)calculateCellHight;

@end

NS_ASSUME_NONNULL_END
