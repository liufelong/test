//
//  FLChaperListController.m
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/30.
//

#import "FLChaperListController.h"
#import "FLReaderController.h"

#import "FLChapterListCell.h"

@interface FLChaperListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/*!背景图片*/
@property (strong, nonatomic) UIImageView *bgImage;

@end

@implementation FLChaperListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.text = self.bookModel.bookname;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self changeReadType];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.chapterModel) {
        //获取到需要跳转位置的行数
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:self.chapterModel.chapterId.intValue - 1 inSection:0];
        //滚动到其相应的位置
        [self.tableView scrollToRowAtIndexPath:scrollIndexPath
                atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)changeReadType {
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.bgImage = [[UIImageView alloc] init];
    self.bgImage.frame = self.view.bounds;
    [self.view addSubview:self.bgImage];
    [self.view sendSubviewToBack:self.bgImage];
    
    if (FLUSER.isNight) {
        self.bgImage.image = [UIImage imageNamed:@"pic_theme_black"];
        self.bgImage.hidden = NO;
    }else {
        [self setDayBgImage];
    }
}

//设置日间模式的背景
- (void)setDayBgImage {
    
    NSString *bgName = FLUSER.bgName;
    if([FLAlertTool isNullObj:bgName]){
        bgName = @"icon_theme_kraftpic";
    }
/**
 icon_theme_white       FFFFFF
 icon_theme_gray        EBEBEB
 icon_theme_green       CBECD1
 icon_theme_greenpic    pic_theme_green
 icon_theme_kraftpic    pic_theme_kraft
 icon_theme_pink        E5C8C8
 icon_theme_pinkpic     pic_theme_pink
 */
    if ([bgName containsString:@"pic"]) {
        self.bgImage.hidden = NO;
        NSString *imName = [bgName stringByReplacingOccurrencesOfString:@"pic" withString:@""];
        imName = [imName stringByReplacingOccurrencesOfString:@"icon" withString:@"pic"];
        self.bgImage.image = [UIImage imageNamed:imName];
    }else {
        self.bgImage.hidden = YES;
        if ([bgName containsString:@"white"]) {
            self.view.backgroundColor = R_G_B_16(0XFFFFFF);
        }else if ([bgName containsString:@"gray"]) {
            self.view.backgroundColor = R_G_B_16(0XEBEBEB);
        }else if ([bgName containsString:@"green"]) {
            self.view.backgroundColor = R_G_B_16(0XCBECD1);
        }else if ([bgName containsString:@"pink"]) {
            self.view.backgroundColor = R_G_B_16(0XE5C8C8);
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookModel.chapterArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FLChapterModel *chapterModel = self.bookModel.chapterArr[indexPath.row];
    
    FLChapterListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FLChapterListCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FLChapterListCell" owner:nil options:nil][0];
    }
    cell.chapterNameLabel.text = chapterModel.title;
    cell.backgroundColor = [UIColor clearColor];
    if (FLUSER.isNight) {
        cell.chapterNameLabel.textColor = [UIColor whiteColor];
    }else {
        cell.chapterNameLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FLReaderController class]]) {
            FLReaderController *readVC = (FLReaderController *)controller;
            FLChapterModel *chapter = self.bookModel.chapterArr[indexPath.row];
            [readVC reloadWithChapter:chapter];
            [self.navigationController popToViewController:readVC animated:YES];
            return;
        }
    }
    
    self.bookModel.lastRead = self.bookModel.chapterArr[indexPath.row];
    self.bookModel.lastPage = 0;
    FLReaderController *readVC = [[FLReaderController alloc] init];
    readVC.bookModel = self.bookModel;
    readVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:readVC animated:YES];
}

@end
