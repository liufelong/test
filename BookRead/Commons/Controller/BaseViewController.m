//
//  BaseViewController.m
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/16.
//

#import "BaseViewController.h"
#import "UIImage+Extenion.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBaseView];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"new_navigation"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    if (@available(iOS 15.0,*)) {
        UINavigationBarAppearance *navigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"new_navigation"]];
        [navigationBarAppearance setShadowImage:[UIImage createImageWithColor:CX_THEME_COLOR andSize:CGSizeMake(SCREEN_WIDTH,1)]];
        self.navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance;
        self.navigationController.navigationBar.standardAppearance = navigationBarAppearance;
    }
    self.titleLabel.textColor = CX_COLOR_FFF;
    [self.leftButton setImage:[UIImage imageNamed:@"MI_back"] forState:UIControlStateNormal];
}

- (void)changeNavStyle {

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"new_navigation"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    if (@available(iOS 15.0,*)) {
        UINavigationBarAppearance *navigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"new_navigation"]];
        [navigationBarAppearance setShadowImage:[UIImage createImageWithColor:CX_THEME_COLOR andSize:CGSizeMake(SCREEN_WIDTH,1)]];
        self.navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance;
        self.navigationController.navigationBar.standardAppearance = navigationBarAppearance;
    }
    self.titleLabel.textColor = CX_COLOR_FFF;
    [self.leftButton setImage:[UIImage imageNamed:@"MI_back"] forState:UIControlStateNormal];
}

- (void)createBaseView {
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame=CGRectMake(0, 0, 30, 44);
    [self.leftButton addTarget:self action:@selector(navbanckBtnClick) forControlEvents:UIControlEventTouchDown];
    [self.leftButton setImage:[UIImage imageNamed:@"IQButtonBarArrowLeft"] forState:UIControlStateNormal];
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = leftBar;
        
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame=CGRectMake(0, 0, 30, 44);
    
    self.rightButton.hidden = YES;
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightBar;
    CGFloat width = SCREEN_WIDTH - 120;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , width, 44)];
    self.titleLabel.text = self.title;
    self.titleLabel.textColor = R_G_B_16(0xffffff);//设置文本颜色
    [self.titleLabel setFont:[UIFont systemFontOfSize:18]];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = self.titleLabel;
}

- (void)navbanckBtnClick {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
