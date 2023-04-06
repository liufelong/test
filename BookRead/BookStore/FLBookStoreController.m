//
//  FLBookStoreController.m
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/25.
//

#import "FLBookStoreController.h"
#import "FLChaperListController.h"

@interface FLBookStoreController ()
@property (weak, nonatomic) IBOutlet UITextView *urlField;

@end

@implementation FLBookStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)readBtn:(id)sender {
    [self.view endEditing:YES];
    
    NSString *url = self.urlField.text;
    
//    url = @"https://wujixsw.com/11_11550/";
//    url = @"http://www.biqu5200.net/0_7/";
//    url = @"https://www.ddxs.cc/ddxs/183711/";
//    url = @"http://www.luoshenol.com/book/70_70419/";
//    url = @"https://www.ixuanshu.org/book/141/";
//    url = @"http://www.biquge.info/74_74132/?kkzqfa=kf0pk3&uirspm=k1sx03";
//    url = @"https://www.121du.cc/12340/";
    
//    NSURL *baseUrl = [NSURL URLWithString:@"https://www.121du.cc/12340"];
//    NSURL *url = [NSURL URLWithString:@"/12340/51156.html" relativeToURL:baseUrl];
//    NSLog(@"%@",[url absoluteString]);
    
    if (url.length == 0) {
        [FLAlertTool alertWithTitle:@"提示" message:@"请粘贴目录地址"];
        return;
    }
    [FLReaderTool readHTMLElementWith:url succesBolck:^(FLBookModel * _Nonnull bookModel) {
        [self jumpToChapterList:bookModel];
    }];
}

- (void)jumpToChapterList:(FLBookModel *)bookModel {
    FLChaperListController *readerController = [[FLChaperListController alloc] init];
    readerController.bookModel = bookModel;
    readerController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:readerController animated:YES];
}

@end
