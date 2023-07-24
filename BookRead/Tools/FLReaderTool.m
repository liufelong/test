//
//  FLReaderTool.m
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/17.
//

#import "FLReaderTool.h"

#import <XPathQuery.h>
#import <TFHpple.h>
#import <TFHppleElement.h>

#import "RequestTool.h"
#import "FLBookModel.h"
#import "FCFileManager.h"

//章节内容div的id
NSString const *contDivId = @"content,content1,BookText";

@implementation FLReaderTool

+ (NSMutableArray *)readerJsonArrayWithFiledName:(NSString *)jsonName {
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return jsonArray;
}

+ (NSMutableDictionary *)readerJsonDictionryWithFiledName:(NSString *)jsonName {
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return jsonArray;
}

#pragma mark 删除数据
+ (void)deleteBookWithName:(NSString *)bookName {
    if ([FLAlertTool isNullObj:bookName]) {
        return;
    }
    NSString *path = [self createNovelNameDictionaryIfNotExist:bookName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:NULL];
}

#pragma mark -- 网页解析相关
#pragma mark 加载章节列表
//通过网络地址读取网页
+ (void)readHTMLElementWith:(NSString *)url succesBolck:(SuccessBolck)succesBolck{
    
    [[RequestTool tool] requsetGetWithUrl:url Success:^(id  _Nonnull result) {
        FLBookModel *bookModel = [self parseNovelCatalogWithData:result withUrl:url];
        bookModel.chapterUrl = url;
        if (bookModel.chapterArr.count == 0) {
            [FLAlertTool alertWithTitle:@"提示" message:@"目录解析错误"];
        }else {
            succesBolck(bookModel);
        }
     } andFailure:^(NSString * _Nonnull errorType) {
         [FLAlertTool alertWithTitle:@"提示" message:@"网络请求错误"];
     }];
    
}

//解析小说的章节目录
+ (FLBookModel *)parseNovelCatalogWithData:(NSData *)data withUrl:(NSString *)url {
    
    FLBookModel *bookModel = [[FLBookModel alloc] init];
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:data];
    TFHppleElement *hppleElement = [hpple peekAtSearchWithXPathQuery:@"//h1"];
    bookModel.bookname = hppleElement.text;
    if (![self isChinese:bookModel.bookname]) {
        hppleElement = [hpple peekAtSearchWithXPathQuery:@"//h2"];
        bookModel.bookname = hppleElement.text;
        if (![self isChinese:bookModel.bookname]) {
            NSStringEncoding strEncode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *daStr = [[NSString alloc] initWithData:data encoding:strEncode];//NSASCIIStringEncoding
            data = [daStr dataUsingEncoding:NSUTF8StringEncoding];

            hpple = [[TFHpple alloc] initWithHTMLData:data];
            TFHppleElement *hppleElement = [hpple peekAtSearchWithXPathQuery:@"//h1"];
            bookModel.bookname = hppleElement.text;
        }
    }
    
    NSLog(@"当前小说的名称为:%@",hppleElement.text);
    
    NSArray *imgElementArr = [hpple searchWithXPathQuery:@"//img"];
    for (TFHppleElement *imgElement in imgElementArr) {
        NSDictionary *dict = imgElement.attributes;
//        NSArray *allKeys = [dict allKeys];
        NSString *src = dict[@"src"];
        NSString *alt = dict[@"alt"];
        if ([src hasPrefix:@"http"] && ([src hasSuffix:@"jpg"] || [src hasSuffix:@"png"])) {
            bookModel.coverimg = dict[@"src"];
        }else if ([alt isEqualToString:hppleElement.text] && ([src hasSuffix:@"jpg"] || [src hasSuffix:@"png"])) {
            NSURL *baseUrl = [NSURL URLWithString:url];
            NSURL *urlImg = [NSURL URLWithString:src relativeToURL:baseUrl];
            bookModel.coverimg = [urlImg absoluteString];
        }
    }
    
    
    NSArray *elements = [hpple searchWithXPathQuery:@"//dd"];
    if (elements.count < 20) {
        elements = [hpple searchWithXPathQuery:@"//li"];
    }else if (elements.count < 20) {
        elements = [hpple searchWithXPathQuery:@"//td"];
    }
    
    int chapterNumb = 1;
    for (int i = 0; i < elements.count; i++) {
        TFHppleElement *element = [elements objectAtIndex:i];
        
        NSArray *childrenElements = [element childrenWithTagName:@"a"];
        
        for (TFHppleElement *e in childrenElements) {
            NSDictionary *dict = e.attributes;
            FLChapterModel *chapter = [[FLChapterModel alloc] init];
            chapter.bookname = bookModel.bookname;
            if (dict[@"title"]) {
                chapter.title = dict[@"title"];
            }else {
                NSDictionary *nodeDict = [e valueForKey:@"node"];
                if ([nodeDict valueForKey:@"nodeContent"]) {
                    chapter.title = [nodeDict valueForKey:@"nodeContent"];
                }
            }
            NSString *href = dict[@"href"];
            if (href) {
               
                if (![href hasPrefix:@"http"]) {
                    //解决A标签href使用相对路径 地址拼接后 重复问题
                    NSURL *baseUrl = [NSURL URLWithString:url];
                    NSURL *urlImg = [NSURL URLWithString:href relativeToURL:baseUrl];
                    href = [urlImg absoluteString];
                }
                chapter.url = href;
            }
            int tempNo = 0;
            if (chapter.title.length > 3){
                tempNo = [chapter.title substringToIndex:3].intValue;
            }
            if (tempNo == 1 || [chapter.title containsString:@"第"] || (bookModel.chapterArr.count > 0)) {
                chapter.chapterId = [NSString stringWithFormat:@"%d",chapterNumb];
                chapterNumb++;
                [bookModel.chapterArr addObject:chapter];
            }
           
        }
    }
    
    return bookModel;
    
}

//解决A标签href使用相对路径 地址拼接后 重复问题
+ (NSString *)removeOverUrl:(NSString *)href {
    NSError *error;
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"/" options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error) {
        NSArray *results = [regular matchesInString:href options:NSMatchingReportProgress range:NSMakeRange(0, href.length)];
        if (results.count > 0) {
            NSTextCheckingResult *last = results.lastObject;
            href = [href substringFromIndex:last.range.location + 1];
        }
    }
    return href;
}

+ (BOOL)isNormalHtmlData:(NSData *)data {
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *h1Arr = [hpple searchWithXPathQuery:@"//h1"];
    for (TFHppleElement *hppleElement in h1Arr) {
        if (hppleElement.text != nil) {
            return YES;
        }
    }
    return NO;
}


#pragma mark 加载章节内容

+ (void)requstGetChapterContent:(FLChapterModel *)chapterModel andSuccess:(StringBolck)block{
    
    NSString *fileName = [chapterModel.title stringByAppendingPathExtension:@"txt"];
    NSString *path = [self createNovelNameDictionaryIfNotExist:chapterModel.bookname];
    NSString *destinationPath = [path stringByAppendingPathComponent:fileName];
    
    if ([FCFileManager existsItemAtPath:destinationPath]) {
        NSString *content = [NSString stringWithContentsOfFile:destinationPath encoding:NSUTF8StringEncoding error:nil];
        block(content);
        return;
    }
    
    if ([FLAlertTool isNullObj:chapterModel.url]) {
        [FLAlertTool alertWithTitle:@"提示" message:@"章节地址错误"];
        return;
    }
    
    [[RequestTool tool] requsetGetWithUrl:chapterModel.url Success:^(id  _Nonnull result) {
        NSDictionary *dict = @{@"url":MAKESURE(chapterModel.url),
                               @"path":destinationPath};
        [self parseHtmlWithData:result andPathDict:dict andSuccess:^(NSString * _Nonnull content) {
            block(content);
        }];

     } andFailure:^(NSString * _Nonnull errorType) {
         [FLAlertTool alertWithTitle:@"提示" message:@"网络请求错误"];
     }];
}

+ (void)reqeustDownloadWithChapter:(FLChapterModel *)chapter {
    
    NSString *fileName = [chapter.title stringByAppendingPathExtension:@"txt"];
    NSString *path = [self createNovelNameDictionaryIfNotExist:chapter.bookname];
    NSString *destinationPath = [path stringByAppendingPathComponent:fileName];
    if ([FCFileManager existsItemAtPath:destinationPath]) {
        return;
    }
    
    [[RequestTool tool] requsetGetDownloadWithUrl:chapter.url Success:^(id  _Nonnull result) {
        NSDictionary *dict = @{@"url":MAKESURE(chapter.url),
                               @"download":@"1",
                               @"path":destinationPath};
        [self parseHtmlWithData:result andPathDict:dict andSuccess:^(NSString * _Nonnull content) {
            
        }];
    } andFailure:^(NSString * _Nonnull errorType) {
            
    }];
}

+ (void)requestHtmlNextPage:(TFHppleElement *)nextAPage pathDict:(NSDictionary *)pathDict andSuccess:(StringBolck)block {
    
    NSDictionary *aPagDict = nextAPage.attributes;
    NSString *href = aPagDict[@"href"];
    href = [self removeOverUrl:href];
    NSString *url = pathDict[@"url"];
    
    NSError *error;
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"/" options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error) {
        NSArray *results = [regular matchesInString:url options:NSMatchingReportProgress range:NSMakeRange(0, url.length)];
        if (results.count > 0) {
            NSTextCheckingResult *last = results.lastObject;
            url = [url substringToIndex:last.range.location + 1];
        }
    }
    url = [url stringByAppendingString:href];
    
    NSString *download = pathDict[@"download"];
    if ([download isEqualToString:@"1"]) {
        //悄悄下载 不转圈
        [[RequestTool tool] requsetGetDownloadWithUrl:url Success:^(id  _Nonnull result) {
            [self parseHtmlWithData:result andPathDict:pathDict andSuccess:^(NSString * _Nonnull content) {
                block(content);
            }];
        } andFailure:^(NSString * _Nonnull errorType) {
                
        }];
        
    }else {
        [[RequestTool tool] requsetGetWithUrl:url Success:^(id  _Nonnull result) {
            [self parseHtmlWithData:result andPathDict:pathDict andSuccess:^(NSString * _Nonnull content) {
                block(content);
            }];
        } andFailure:^(NSString * _Nonnull errorType) {
                
        }];
    }
    
    
}

/**
   pathDict =@{@"url":章节地址,
               @"path":缓存地址}
 */
+ (void)parseHtmlWithData:(NSData *)data andPathDict:(NSDictionary *)pathDict andSuccess:(StringBolck)block{
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:data];
    
    NSArray *elements = [hpple searchWithXPathQuery:@"//div"];
    
    NSString *path = pathDict[@"path"];
    
    for (int i = 0; i < elements.count; i++) {
        TFHppleElement *e = [elements objectAtIndex:i];
        NSString *divId = MAKESURE([[e attributes] objectForKey:@"id"]);
        NSString *class = MAKESURE([[e attributes] objectForKey:@"class"]);
        if ([contDivId containsString:divId] || [contDivId containsString:class]) {
            NSString *content = [e.raw copy];
            content = [self filterSepcialSymbol:content];
            NSLog(@"过滤后的字符串的内容为:%@",content);
            if ([self isChinese:content]) {
                TFHppleElement *nextAPage = [self getNextAPage:data];
                NSString *temConten = pathDict[@"content"];
                if (temConten.length > 0) {
                    content = [NSString stringWithFormat:@"%@\n%@",temConten,content];
                }
                if (nextAPage) {
                    NSMutableDictionary *temDict = pathDict.mutableCopy;
                    [temDict setValue:content forKey:@"content"];
                    
                    [self requestHtmlNextPage:nextAPage pathDict:temDict andSuccess:block];
                    
                }else {
                    [self writeToFileByContent:content withPath:path];
                    block(content);
                }
            }else {
                //获取到文本没有汉字就重新编码一下
                [self parseHtmlAgenWithData:data andPathDict:pathDict andSuccess:block];
            }
            return;
        }
//        NSLog(@"1 : %@",[e text]);
//        NSLog(@"2 : %@",[e tagName]);
//        NSLog(@"3 : %@",[e attributes]);
//        NSLog(@"4 : %@",[e objectForKey:@"href"]);
//        NSLog(@"5 : %@",[e firstChildWithTagName:@"meta"]);
//        NSLog(@"------完成对一个文件的解析--------");
    }
}

+ (void)parseHtmlAgenWithData:(NSData *)data andPathDict:(NSDictionary *)pathDict andSuccess:(StringBolck)block{
   
    NSStringEncoding strEncode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *daStr = [[NSString alloc] initWithData:data encoding:strEncode];//NSASCIIStringEncoding
    data = [daStr dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:data];
    
    NSArray *elements = [hpple searchWithXPathQuery:@"//div"];

    NSString *path = pathDict[@"path"];
    
    for (int i = 0; i < elements.count; i++) {
        TFHppleElement *e = [elements objectAtIndex:i];
        NSString *divId = MAKESURE([[e attributes] objectForKey:@"id"]);
        if ([contDivId containsString:divId]) {
            NSString *content = [e.raw copy];
            content = [self filterSepcialSymbol:content];
            NSLog(@"过滤后的字符串的内容为:%@",content);
            TFHppleElement *nextAPage = [self getNextAPage:data];
            NSString *temConten = pathDict[@"content"];
            if (temConten.length > 0) {
                content = [NSString stringWithFormat:@"%@\n%@",temConten,content];
            }
            
            if (nextAPage) {
                NSMutableDictionary *temDict = pathDict.mutableCopy;
                [temDict setValue:content forKey:@"content"];
                
                [self requestHtmlNextPage:nextAPage pathDict:temDict andSuccess:block];
                
            }else {
                [self writeToFileByContent:content withPath:path];
                block(content);
            }
            return;
        }
    }
}

//解析出来的文本是否有汉字
+ (BOOL)isChinese:(NSString *)string {
    for (int i = 0; i < string.length; i++) {
        int a = [string characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

+ (TFHppleElement *)getNextAPage:(NSData *)data{
    
    NSString *htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (![htmlString containsString:@"下一页</a>"]) {
        return nil;
    }
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements = [hpple searchWithXPathQuery:@"//a"];
    for (TFHppleElement *e in elements) {
        NSDictionary *dict = e.attributes;
        NSString *title = dict[@"title"];
        if (title.length == 0) {
            NSDictionary *nodeDict = [e valueForKey:@"node"];
            if ([nodeDict valueForKey:@"nodeContent"]) {
                title = [nodeDict valueForKey:@"nodeContent"];
            }
        }
        if ([title isEqualToString:@"下一页"]) {
            return e;
        }
    }
    return nil;
}

+ (void)writeToFileByContent:(NSString *)content withPath:(NSString *)destinationPath{

    if (![FCFileManager existsItemAtPath:destinationPath]) {
        NSError *err = nil;
        [FCFileManager createFileAtPath:destinationPath error:&err];
        if (err) {
            NSLog(@"创建小说txt失败的原因是:%@",err);
        } else {
            NSLog(@"小说文件创建成功");
        }
    }
    NSError *error = nil;
    [content writeToFile:destinationPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"写入文件失败的原因是%@",error);
    }
}

+ (NSString *)filterSepcialSymbol:(NSString *)content {
    content = [content stringByReplacingOccurrencesOfString:@"<br /><br />" withString:@"\n"];
    content = [content stringByReplacingOccurrencesOfString:@"<br/><br/>" withString:@"\n"];
    content = [content stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    content = [content stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n   "];
    
    content = [content stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    
    content = [self JJFilterHTML:content];
    return content;
}

//去除字符串中的剩余标签
+ (NSString *)JJFilterHTML:(NSString *)html {
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd] == NO) {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
    html = [html stringByReplacingOccurrencesOfString:@"&#13;" withString:@""];
    return html;
}

+ (NSString *)createNovelNameDictionaryIfNotExist:(NSString *)bookName {
    if (!bookName || bookName.length == 0) {
        return @"";
    }
    NSString *path = [FCFileManager pathForLibraryDirectoryWithPath:@"Novel"];
    NSString *destinationPath = [path stringByAppendingPathComponent:bookName];
    NSLog(@"当前的沙盒存储地址为:%@",destinationPath);
    if ([FCFileManager existsItemAtPath:destinationPath]) {
        return destinationPath;
    }
    NSError *error = nil;
    if (![FCFileManager createDirectoriesForPath:destinationPath error:&error]) {
        NSLog(@"Error create directories %@ , %@",destinationPath, error);
    }
    return destinationPath;
}

@end
