//
//  FLReadDetailController.m
//  BookRead
//
//  Created by 刘飞龙 on 2023/3/20.
//

#import "FLReadDetailController.h"

@interface FLReadDetailController ()

/*!背景图片*/
@property (strong, nonatomic) UIImageView *bgImage;

@end

@implementation FLReadDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bgImage = [[UIImageView alloc] init];
    self.bgImage.frame = self.view.bounds;
    [self.view addSubview:self.bgImage];
    [self.view sendSubviewToBack:self.bgImage];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(TAB_SAFE_HEIGHT);
        make.bottom.equalTo(self.view).offset(-TAB_SAFE_HEIGHT - 20);
    }];
    
    UIButton *showMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showMenuBtn addTarget:self action:@selector(showAndHiddMenu) forControlEvents:UIControlEventTouchUpInside];
    showMenuBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:showMenuBtn];
    [showMenuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(150);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeReadType) name:ChangeReadType object:nil];
    
    
    self.chapterTitleLabel = [[UILabel alloc] init];
    self.chapterTitleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.chapterTitleLabel];
    [self.chapterTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(20);
        make.top.equalTo(self.textView.mas_bottom);
    }];
    
    self.pageLabel = [[UILabel alloc] init];
    self.pageLabel.font = [UIFont systemFontOfSize:14];
    self.pageLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.pageLabel];
    [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.textView.mas_bottom);
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    
    if (self.chapterModel.textArray.count == 0) {

        [self.chapterModel pagingWithContentString:self.chapterModel.text contentSize:TEXTSIZE];
    }
    if (self.itemIndex > self.chapterModel.textArray.count - 1) {
        self.itemIndex = 0;
    }
    
    if (self.chapterModel.textArray.count == 0) {
        return;
    }
    
    self.textView.attributedText = self.chapterModel.textArray[self.itemIndex];
    NSLog(@"%@", self.chapterModel.textArray[self.itemIndex]);
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.itemIndex + 1,self.chapterModel.textArray.count];
    self.chapterTitleLabel.text = self.chapterModel.title;
    if (self.itemIndex == 0) {
        self.chapterTitleLabel.text = self.chapterModel.bookname;
    }
    [self changeReadType];
}

- (void)changeReadType {
    if (FLUSER.isNight) {
        self.bgImage.image = [UIImage imageNamed:@"pic_theme_black"];
        self.textView.textColor = [UIColor whiteColor];
        self.pageLabel.textColor = [UIColor whiteColor];
        self.chapterTitleLabel.textColor = [UIColor whiteColor];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        self.bgImage.hidden = NO;
    }else {
        self.textView.textColor = [UIColor blackColor];
        self.pageLabel.textColor = [UIColor blackColor];
        self.chapterTitleLabel.textColor = [UIColor blackColor];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [self setDayBgImage];
    }
}

- (void)showAndHiddMenu {
    if (self.menuBlock) {
        self.menuBlock();
    }
}

//设置日间模式的背景
- (void)setDayBgImage {
    
    NSString *bgName = FLUSER.bgName;
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:ChangeReadType];
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.editable = NO;
        _textView.selectable = NO;
        _textView.scrollEnabled = NO;
        _textView.textContainerInset = UIEdgeInsetsZero;
        _textView.backgroundColor = [UIColor clearColor];
    }
    return _textView;
}

@end
