//
//  FLChapterModel.h
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/17.
//  章节模型

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface FLChapterModel : NSObject<NSCoding,NSCopying>

/*!<#备注#>*/
@property (copy, nonatomic) NSString *chapterId;

/*!<#备注#>*/
@property (copy, nonatomic) NSString *bookname;
/*!章节标题*/
@property (copy, nonatomic) NSString *title;
/*!文本内容*/
@property (copy, nonatomic) NSString *text;
/*!分页文本*/
@property (strong, nonatomic) NSMutableArray *textArray;

/*!url*/
@property (copy, nonatomic) NSString *url;

//分页
//- (void)getChapterArrWithDetailConroller:(FLReadDetailController *)readVC;

- (void)pagingWithcontentSize:(CGSize)contentSize;

-(NSMutableArray *)pagingWithContentString:(NSString *)contentString contentSize:(CGSize)contentSize;

@end

NS_ASSUME_NONNULL_END
