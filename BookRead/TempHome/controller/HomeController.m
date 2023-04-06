//
//  HomeController.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/3/20.
//

#import "HomeController.h"

#import "FLReadControllerT.h"

@interface HomeController ()<UITableViewDelegate,UITableViewDataSource>

/*!<#备注#>*/
@property (strong, nonatomic) NSArray *fontFamilyNames;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.view addSubview:self.tableView];
     self.title = @"首页";
//     self.automaticallyAdjustsScrollViewInsets = NO;
        self.view.backgroundColor = [UIColor whiteColor];
    _fontFamilyNames = [UIFont familyNames];
    
    
    NSLog(@"%@",_fontFamilyNames);
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"行楷" style:UIBarButtonItemStylePlain target:self action:@selector(chooseCustomFont)];
}

- (void)chooseCustomFont {
//    DDPagingTextVC *vc = [[DDPagingTextVC alloc] init];
//    vc.fontName = @"STXingkai";
//    [self.navigationController pushViewController:vc animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fontFamilyNames.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _fontFamilyNames[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fontName = _fontFamilyNames[indexPath.row];
    FLReadControllerT *vc = [[FLReadControllerT alloc] init];
    vc.fontName = fontName;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
    
}

@end
