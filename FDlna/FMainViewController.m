//
//  FMainViewController.m
//  FDlna
//
//  Created by GaoAng on 2019/3/15.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import "FMainViewController.h"
#import "FLocalMusicServices.h"
#import "FMusicTableViewCell.h"
#import "FDiscoveryViewController.h"
#import "SOSoundBoxPlayer.h"

@interface FMainViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong)  NSArray *mSourceDatas;
@end

@implementation FMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SOSoundBoxPlayer sharedPlayer] startDLNA];
    
    [self.mNavView setBackgroundColorClear];
    [self.mNavView setTitle:@"主页"];
    [self.mNavView setBackgroundColor:[UIColor greenColor]];
    [self.mNavView.mRightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.mNavView.mRightButton addTarget:self action:@selector(rightButtonAciont:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mTableView];
    [self requestLocalMusicData];
}

- (void)rightButtonAciont:(UIButton*)sender{
    FDiscoveryViewController *vc = [[FDiscoveryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 16.0f : 32.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? 80.0f : 44.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mSourceDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FMusicTableViewCell class])];
    [cell setMItem: [self.mSourceDatas objectAtIndex:indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableView*)mTableView{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_H, SCREEN_W, SCREEN_H -NAVBAR_H) style:UITableViewStyleGrouped];
        _mTableView.separatorColor = _mTableView.backgroundColor;
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        [_mTableView registerClass:[FMusicTableViewCell class] forCellReuseIdentifier:NSStringFromClass([FMusicTableViewCell class])];

    }
    return _mTableView;
}

- (void)requestLocalMusicData{
     [[FLocalMusicServices sharedInstance]  fetchLocalMusicAssetsWithCompletion:^(NSArray *loacalItems) {
         self.mSourceDatas =  loacalItems;
         [self.mTableView reloadData];
    }];
}


@end
