//
//  FLReaderController.m
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/17.
//

#import "FLReaderController.h"
#import "FLReadDetailController.h"
#import "FLChaperListController.h"


#import "FLMenuView.h"

@interface FLReaderController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

/*!隐藏菜单*/
@property (assign, nonatomic) BOOL hidMenu;

/*!当前章节模型*/
@property (strong, nonatomic) FLChapterModel *chapterModel;

@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) NSUInteger nextIndex;

@property (nonatomic, strong) UIPageViewController *pageViewController;

/*!<#备注#>*/
@property (strong, nonatomic) FLMenuView *menuView;

@end

@implementation FLReaderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self changeNavStyle];
    self.navigationController.navigationBar.hidden = YES;
    self.hidMenu = YES;
    self.titleLabel.text = self.bookModel.bookname;
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self createTextArray];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidMenumView) name:HiddenMune object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidMenumView];
}

- (void)createTextArray{
    self.chapterModel = [[FLChapterModel alloc] init];
    
    FLChapterModel *chapter = self.bookModel.lastRead;
    if (!chapter) {
        chapter = self.bookModel.chapterArr.firstObject;
        self.bookModel.lastPage = 0;
    }
        
    NSDictionary *dict = [chapter mj_keyValues];
    [self.chapterModel setValuesForKeysWithDictionary:dict];
    [self.chapterModel.textArray removeAllObjects];
    
    [FLReaderTool requstGetChapterContent:self.chapterModel andSuccess:^(NSString * _Nonnull content) {
        self.chapterModel.text = content;
        [self createPageController];
    }];
}


- (void)createPageController {

    self.pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                              options:@{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)}];
    
    FLReadDetailController *firstVC = [self viewControllerAtIndex:self.bookModel.lastPage?self.bookModel.lastPage:0];
    [self.pageViewController setViewControllers:@[firstVC]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    self.pageViewController.view.frame = self.view.bounds;
    
    // 添加视图控制器、视图。
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    [self.pageViewController didMoveToParentViewController:self];
    
    CGFloat hieght = 280 + TAB_SAFE_HEIGHT;
    self.menuView = [[NSBundle mainBundle] loadNibNamed:@"FLMenuView" owner:nil options:nil][0];
    self.menuView.frame = CGRectMake(0, SCREEN_HEIGHT - hieght, SCREEN_WIDTH, hieght);
    self.menuView.hidden = YES;
    self.menuView.typeBtn.selected = FLUSER.isNight;
    WS(weakSelf);
    self.menuView.btnBlock = ^(MenuBtnTag tag) {
        if (tag == BeforeChapter) {
            [weakSelf loadBeforeChapter:NO];
        }else if (tag == NextChapter) {
            [weakSelf loadNextChapter];
        }else if (tag == CatalogAction) {
            //不隐藏菜单
            [weakSelf jumpToChapterList];
            return;
        }else if (tag == FontReduce || tag == FontAdd) {
            //不隐藏菜单
            [weakSelf changeFontSize];
            return;
        }
        [weakSelf hidMenumView];
    };
    [self.view addSubview:self.menuView];
    
}

- (void)showAndHiddMenu {
    if (self.hidMenu) {
        self.navigationController.navigationBar.hidden = NO;
        self.hidMenu = NO;
    }else {
        self.navigationController.navigationBar.hidden = YES;
        self.hidMenu = YES;
    }
    
    if (!self.menuView) {
        CGFloat hieght = 280 + TAB_SAFE_HEIGHT;
        self.menuView = [[NSBundle mainBundle] loadNibNamed:@"FLMenuView" owner:nil options:nil][0];
        self.menuView.frame = CGRectMake(0, SCREEN_HEIGHT - hieght, SCREEN_WIDTH, hieght);
        self.menuView.hidden = YES;
        self.menuView.typeBtn.selected = FLUSER.isNight;
        WS(weakSelf);
        self.menuView.btnBlock = ^(MenuBtnTag tag) {
            if (tag == BeforeChapter) {
                [weakSelf loadBeforeChapter:NO];
            }else if (tag == NextChapter) {
                [weakSelf loadNextChapter];
            }else if (tag == CatalogAction) {
                [weakSelf jumpToChapterList];
            }else if (tag == FontReduce || tag == FontAdd) {
                [weakSelf changeFontSize];
            }
        };
        [self.view addSubview:self.menuView];
    }
    
    self.menuView.hidden = self.hidMenu;
    if (!self.hidMenu) {
        self.menuView.progressView.progress = self.chapterModel.chapterId.intValue / self.bookModel.chapterArr.count;
    }
}

- (void)hidMenumView {
    self.navigationController.navigationBar.hidden = YES;
    self.hidMenu = YES;
    self.menuView.hidden = YES;
}

- (void)navbanckBtnClick {

    self.bookModel.lastRead = self.bookModel.chapterArr[self.chapterModel.chapterId.intValue - 1];
    self.bookModel.lastPage = self.currentIndex;
    if (![FLUSER.bookArray containsObject:self.bookModel]) {
        WS(weakSelf);
        [FLAlertTool alertWithTitle:@"提示" message:@"是否保存本这本书" confirmBlock:^{
            [FLUSER.bookArray enumerateObjectsUsingBlock:^(FLBookModel * _Nonnull bookModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([bookModel.bookname isEqualToString:weakSelf.bookModel.bookname]) {
                    [FLUSER.bookArray removeObject:bookModel];
                    [FLReaderTool deleteBookWithName:bookModel.bookname];
                }
            }];
            [FLUSER.bookArray insertObject:self.bookModel atIndex:0];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:ReloadBookShelf object:nil];
        } cancelBlock:^{
            [FLReaderTool deleteBookWithName:self.bookModel.bookname];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }else {
        [FLUSER.bookArray removeObject:self.bookModel];
        [FLUSER.bookArray insertObject:self.bookModel atIndex:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:ReloadBookShelf object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - 控制
//调整了字体大小
- (void)changeFontSize {
    [self.chapterModel pagingWithContentString:self.chapterModel.text contentSize:TEXTSIZE];
    NSInteger tag = self.currentIndex;
    if (self.chapterModel.textArray.count - 1 < tag) {
        tag = self.chapterModel.textArray.count - 1;
    }
    FLReadDetailController *firstVC = [self viewControllerAtIndex:tag];
    [self.pageViewController setViewControllers:@[firstVC]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
}

//跳转到目录页面
- (void)jumpToChapterList {
    FLChaperListController *chapterList = [[FLChaperListController alloc] init];
    chapterList.bookModel = self.bookModel;
    chapterList.chapterModel = self.chapterModel;
    [self.navigationController pushViewController:chapterList animated:YES];
}

//加载指定章节
- (void)reloadWithChapter:(FLChapterModel *)model {
    NSDictionary *dict = [model mj_keyValues];
    [self.chapterModel setValuesForKeysWithDictionary:dict];
    self.chapterModel.text = @"";
    [self.chapterModel.textArray removeAllObjects];
    
    WS(weakSelf);
    [FLReaderTool requstGetChapterContent:self.chapterModel andSuccess:^(NSString * _Nonnull content) {
        weakSelf.chapterModel.text = content;
        [weakSelf.chapterModel pagingWithContentString:weakSelf.chapterModel.text contentSize:TEXTSIZE];
        FLReadDetailController *firstVC = [weakSelf viewControllerAtIndex:0];
        [weakSelf.pageViewController setViewControllers:@[firstVC]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
    }];
    
    //悄悄的缓存下一章节
    if (self.chapterModel.chapterId.intValue < self.bookModel.chapterArr.count) {
        FLChapterModel *nextModel = self.bookModel.chapterArr[self.chapterModel.chapterId.intValue];
        [FLReaderTool reqeustDownloadWithChapter:nextModel];
    }
}

#pragma mark 加载上/下一章
- (void)loadNextChapter {
    if (self.chapterModel.chapterId.intValue == self.bookModel.chapterArr.count) {
        [FLAlertTool alertWithTitle:@"提示" message:@"后面没有了"];
        return;
    }
    FLChapterModel *nextModel = self.bookModel.chapterArr[self.chapterModel.chapterId.intValue];
    NSDictionary *nextDict = [nextModel mj_keyValues];
    [self.chapterModel setValuesForKeysWithDictionary:nextDict];
    [self.chapterModel.textArray removeAllObjects];
    self.chapterModel.text = @"";
    WS(weakSelf);
    [FLReaderTool requstGetChapterContent:self.chapterModel andSuccess:^(NSString * _Nonnull content) {
        weakSelf.chapterModel.text = content;
        [weakSelf.chapterModel pagingWithContentString:weakSelf.chapterModel.text contentSize:TEXTSIZE];
        FLReadDetailController *firstVC = [weakSelf viewControllerAtIndex:0];
        weakSelf.currentIndex = 0;
        [self.pageViewController setViewControllers:@[firstVC]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
    }];
    
    //悄悄的缓存下一章节
    if (self.chapterModel.chapterId.intValue < self.bookModel.chapterArr.count) {
        nextModel = self.bookModel.chapterArr[self.chapterModel.chapterId.intValue];
        [FLReaderTool reqeustDownloadWithChapter:nextModel];
    }
}

//加载上一章 是否通过翻页过来的
- (void)loadBeforeChapter:(BOOL)pageChange {
    if ([self.chapterModel.chapterId isEqualToString:@"1"]) {
        //当前为第一章
        [FLAlertTool alertWithTitle:@"提示" message:@"前面没有了"];
        return;
    }
    
    FLChapterModel *beforeModel = self.bookModel.chapterArr[self.chapterModel.chapterId.intValue - 2];
    NSDictionary *beforeDict = [beforeModel mj_keyValues];
    [self.chapterModel setValuesForKeysWithDictionary:beforeDict];
    [self.chapterModel.textArray removeAllObjects];
    WS(weakSelf);
    [FLReaderTool requstGetChapterContent:self.chapterModel andSuccess:^(NSString * _Nonnull content) {
        weakSelf.chapterModel.text = content;
        NSInteger tag = 0;
        if (pageChange) {
            //翻页过来的就加载最后一页
            [weakSelf.chapterModel pagingWithContentString:self.chapterModel.text contentSize:TEXTSIZE];
            tag = weakSelf.chapterModel.textArray.count - 1;
        }
        weakSelf.currentIndex = tag;
        FLReadDetailController *firstVC = [self viewControllerAtIndex:tag];
        [self.pageViewController setViewControllers:@[firstVC]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
    }];
}

#pragma mark - UIPageViewControllerDataSource
- (FLReadDetailController *)viewControllerAtIndex:(NSUInteger)index {
    // 返回指定index的视图控制器
    
    FLReadDetailController *detailVC = [[FLReadDetailController alloc] init];
    detailVC.chapterModel = self.chapterModel;
    detailVC.itemIndex = index;
    detailVC.menuBlock = ^{
        [self showAndHiddMenu];
    };
    return detailVC;
}

//返回当前页面的前一个页面
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = ((FLReadDetailController *)viewController).itemIndex;
    if (index == NSNotFound) {
        return nil;
    }
    if (index == 0) {
        [self loadBeforeChapter:YES];
        return nil;
    }
    --index;
    return [self viewControllerAtIndex:index];
}

//返回当前页面的后一个页面
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = ((FLReadDetailController *)viewController).itemIndex;
    if (index == self.chapterModel.textArray.count - 1 || index == NSNotFound) {
        if (index == self.chapterModel.textArray.count - 1) {
            
            if (self.chapterModel.chapterId.intValue < self.bookModel.chapterArr.count) {
                [self loadNextChapter];
            }else {
                [FLAlertTool alertWithTitle:@"提示" message:@"没有更多了"];
            }
        }
        return nil;
    }
    ++index;
    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate
// 手势导航开始前调用该方法。
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    // 如果用户终止了滑动导航，transition将不能完成，页面也将保持不变。
    
    FLReadDetailController *dataVC = (FLReadDetailController *)pendingViewControllers.firstObject;
    if (dataVC) {
        self.nextIndex = dataVC.itemIndex;
        
        // 输出滑动方向
        if (self.currentIndex < self.nextIndex) {
            NSLog(@"Forward");
        } else {
            NSLog(@"Backward");
        }
    }
}

// 手势导航结束后调用该方法。
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    // 使用completed参数区分成功导航和中止导航。
    if (completed) {
        self.currentIndex = self.nextIndex;
    }
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (UIInterfaceOrientationIsPortrait(orientation) || ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)) {
        // 设备为phone，或portrait状态时，设置UIPageViewControllerSpineLocation为Min。

        FLReadDetailController *currentVC = self.pageViewController.viewControllers.firstObject;
        [self.pageViewController setViewControllers:@[currentVC]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
        self.pageViewController.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    } else {
        // 在landscape orientation时，设置spine为mid，pageViewController展示两个视图控制器。

        FLReadDetailController *currentVC = self.pageViewController.viewControllers.firstObject;
        NSUInteger indexOfCurrentVC = currentVC.itemIndex;

        NSArray *viewControllers = [NSArray array];

        if (indexOfCurrentVC == 0 || indexOfCurrentVC % 2 == 0) {
            // 如果当前页为偶数，则显示当前页和下一页。
            UIViewController *nextVC = [self pageViewController:self.pageViewController viewControllerAfterViewController:currentVC];
            viewControllers = @[currentVC, nextVC];
        } else {
            // 如果当前页为奇数，则显示上一页和当前页。
            UIViewController *previousVC = [self pageViewController:self.pageViewController viewControllerBeforeViewController:currentVC];
            viewControllers = @[previousVC, currentVC];
        }
        [self.pageViewController setViewControllers:viewControllers
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];

        return UIPageViewControllerSpineLocationMid;
    }
}

- (void)dealloc {
    if ([FLUSER.bookArray containsObject:self.bookModel]) {
        self.bookModel.lastRead = self.bookModel.chapterArr[self.chapterModel.chapterId.intValue - 1];
        self.bookModel.lastPage = self.currentIndex;
        [FLUSER.bookArray removeObject:self.bookModel];
        [FLUSER.bookArray insertObject:self.bookModel atIndex:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:ReloadBookShelf object:nil];
    }
}

@end
