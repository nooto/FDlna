//
//  FBaseViewController.m
//  FDlna
//
//  Created by GaoAng on 2019/3/15.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import "FBaseViewController.h"
#import "SONavigationView/SONavigationView.h"
@interface FBaseViewController () <SONavigationViewDelegate>
@property (nonatomic, strong) SONavigationView *mNavView;
@end

@implementation FBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mNavView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)backBtnPressed:(SONavButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(SONavigationView*)mNavView{
    if (!_mNavView) {
        _mNavView = [[SONavigationView alloc] initWithdelegate:self];
    }
    return _mNavView;
}

@end
