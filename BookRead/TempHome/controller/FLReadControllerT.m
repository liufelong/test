//
//  FLReadControllerT.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/3/20.
//

#import "FLReadControllerT.h"

#import "PagingTextView.h"

@interface FLReadControllerT (){
    CGSize _contentSize;
    NSDictionary *_attributeDict;
    PagingTextView *_pagingTextView;
    CGFloat _fontSize;
}

@end

@implementation FLReadControllerT

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) - 20, CGRectGetHeight(self.view.frame) - (TAB_SAFE_HEIGHT * 2));
    _fontSize = 20;
    
//    UIFont *font = [UIFont fontWithName:self.fontName size:_fontSize];
    
    _attributeDict = @{NSFontAttributeName:[UIFont fontWithName:self.fontName size:_fontSize]};
    self.title = @"文本分隔";
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"小说" ofType:@"txt"];
    NSString *string = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitle:@"A+" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(fontIncrease) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(0, 0, 44, 44);
    [button1 setTitle:@"A-" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(fontDecrease) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    
    
    
    self.navigationItem.rightBarButtonItems = @[rightBarItem,rightBarItem1];
    
    _pagingTextView = [[PagingTextView alloc] initWithFrame:CGRectMake(10, TAB_SAFE_HEIGHT, _contentSize.width, _contentSize.height)];
    _pagingTextView.attributeDict = _attributeDict;
    
    _pagingTextView.contentString = string;
    [self.view addSubview:_pagingTextView];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)fontIncrease {
    _fontSize ++;
    _attributeDict = @{NSFontAttributeName:[UIFont fontWithName:self.fontName size:_fontSize]};
    
    [_pagingTextView updateAttributeDict:_attributeDict];
}

- (void)fontDecrease {
    _fontSize --;
    _attributeDict = @{NSFontAttributeName:[UIFont fontWithName:self.fontName size:_fontSize]};
    [_pagingTextView updateAttributeDict:_attributeDict];
}
@end
