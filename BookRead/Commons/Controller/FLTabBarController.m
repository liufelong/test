//
//  FLTabBarController.m
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/17.
//

#import "FLTabBarController.h"
#import "BaseViewController.h"

#import "FLBookShelfController.h"
#import "FLBookStoreController.h"
#import "FLMineController.h"

#import "AppDelegate.h"

#import "HomeController.h"

@interface FLTabBarController ()

@end

@implementation FLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FLBookShelfController *homeNewVC = [[FLBookShelfController alloc] init];
//    HomeController *homeNewVC = [[HomeController alloc] init];
    [self addChildViewController:homeNewVC title:@"首页" image:@"JTTabBar_home" selImage:@"JTTabBar_home_selected"];

    FLBookStoreController *assignmentVc = [[FLBookStoreController alloc] init];
    [self addChildViewController:assignmentVc title:@"产品" image:@"JTTabBar_pro" selImage:@"JTTabBar_pro_selected"];
    

    FLMineController *mePageNewVC = [[FLMineController alloc] init];
    [self addChildViewController:mePageNewVC title:@"我" image:@"JTTabBar_mine" selImage:@"JTTabBar_mine_selected"];
    
    if (@available(iOS 13.0, *)) {
        self.tabBar.tintColor = JT_THEME_COLOR;
        [[UITabBar appearance] setUnselectedItemTintColor:R_G_B_16(0x756C6C)];
    }
    
    [self changeTabBarLine];
}

- (void)changeTabBarLine{
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,CX_MODULAR_SPLIT_COLOR.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[[UIImage alloc] init]];
}

#pragma mark - 设置子控制器
- (void)addChildViewController:(BaseViewController *)childController title:(NSString *)title image:(NSString *)image selImage:(NSString *)selImage {
    childController.title = title;
    childController.view.backgroundColor = [UIColor whiteColor];
    [childController.tabBarItem setImage:[UIImage imageNamed:image]];
    
    UIImage *sel = [UIImage imageNamed:selImage];
    sel = [sel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [childController.tabBarItem setSelectedImage:sel];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:childController];
    [childController changeNavStyle];
    childController.leftButton.hidden = YES;
    self.tabBar.backgroundColor = [UIColor whiteColor];
    //设置图片
    childController.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置文字格式
    NSMutableDictionary * textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = R_G_B_16(0x756C6C);
    [childController.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    //选中的文字
    NSMutableDictionary * selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = JT_THEME_COLOR;
    [childController.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    [self addChildViewController:navigation];
}

@end
