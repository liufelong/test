//
//  FLReaderTool.h
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/17.
//

#import <Foundation/Foundation.h>
#import "FLBookModel.h"



NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessBolck)(FLBookModel *bookModel);
typedef void(^StringBolck)(NSString *content);
@interface FLReaderTool : NSObject

//读取JSON文件
+ (NSMutableArray *)readerJsonArrayWithFiledName:(NSString *)jsonName;
+ (NSMutableDictionary *)readerJsonDictionryWithFiledName:(NSString *)jsonName;

//通过网络地址读取网页
+ (void)readHTMLElementWith:(NSString *)url succesBolck:(SuccessBolck)succesBolck;

//获取章节内容
+ (void)requstGetChapterContent:(FLChapterModel *)chapterModel andSuccess:(StringBolck)block;

//后台下载章节方法
+ (void)reqeustDownloadWithChapter:(FLChapterModel *)chapter;

//删除本书的缓存章节及文件夹
+ (void)deleteBookWithName:(NSString *)bookName;

@end

NS_ASSUME_NONNULL_END
