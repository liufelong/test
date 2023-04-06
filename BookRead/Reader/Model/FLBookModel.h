//
//  FLBookModel.h
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/17.
//

#import <Foundation/Foundation.h>

#import "FLChapterModel.h"

NS_ASSUME_NONNULL_BEGIN

@class FLTapModel;
@interface FLBookModel : NSObject<NSCoding,NSCopying>

/*!ID*/
@property (copy, nonatomic) NSString *bookid;
/*!书名*/
@property (copy, nonatomic) NSString *bookname;
/*!作者*/
@property (copy, nonatomic) NSString *authorname;
/*!封面*/
@property (copy, nonatomic) NSString *coverimg;
/*!前言*/
@property (copy, nonatomic) NSString *preface;
/*!推荐人数*/
@property (copy, nonatomic) NSString *adviceCount;

@property (copy, nonatomic) NSString *chapterUrl;
/*!章节列表*/
@property (strong, nonatomic) NSMutableArray <FLChapterModel *>*chapterArr;
/*!标签列表*/
@property (strong, nonatomic) NSMutableArray <FLTapModel *>*tapArr;

/*!最近阅读的章节*/
@property (strong, nonatomic) FLChapterModel *lastRead;
/*!最近阅读的页码*/
@property (assign, nonatomic) NSInteger lastPage;

/*!<#备注#>*/
@property (assign, nonatomic) BOOL isSelect;

@end

@interface FLTapModel : NSObject<NSCoding,NSCopying>

//标签内容
@property (copy, nonatomic) NSString *tapname;
//标签颜色
@property (copy, nonatomic) NSString *colorstring;
/*!<#备注#>*/
@property (strong, nonatomic) UIColor *colorUi;

@end

NS_ASSUME_NONNULL_END
