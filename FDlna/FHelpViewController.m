//
//  FHelpViewController.m
//  FDlna
//
//  Created by GaoAng on 2019/3/29.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import "FHelpViewController.h"
#import <WebKit/WebKit.h>

@interface FHelpViewController ()
@property (nonatomic, strong) WKWebView *mWebView;
@end

@implementation FHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.mNavView setBackgroundColor:[UIColor whiteColor]];
    [self.mNavView.mLeftButton setImage:[UIImage imageNamed:@"back_icon_black"] forState:UIControlStateNormal];
    [self.mNavView setTitle:@"帮助"];
    self.mNavView.mRightButton.hidden = YES;
    [self.view addSubview:self.mWebView];
    [_mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://baike.baidu.com/item/DLNA/10415195?fr=aladdin"]]];
}

- (WKWebView*)mWebView{
    if (!_mWebView) {
        _mWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAVBAR_H, SCREEN_W, SCREEN_H - NAVBAR_H)];
        _mWebView.backgroundColor = [UIColor clearColor];
        _mWebView.scrollView.backgroundColor = [UIColor clearColor];
    }
    return _mWebView;
}
@end
