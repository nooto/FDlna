//
//  FDiscoveryViewController.m
//  FDlna
//
//  Created by GaoAng on 2019/3/20.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import "FDiscoveryViewController.h"
#import "FMusicTableViewCell.h"
#import "FLocalMusicServices.h"
#import "SOSoundBoxPlayer.h"
#import "FDiscoveryViewCell.h"

@interface FDiscoveryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong)  NSArray *mSourceDatas;
@end

@implementation FDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mNavView setBackgroundColorClear];
    [self setTitle:@"可用设备"];
    [self.mNavView.mRightButton setTitle:@"重新查找" forState:UIControlStateNormal];
    [self.mNavView.mRightButton addTarget:self action:@selector(rightButtonAciont:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mTableView];
}

- (void)rightButtonAciont:(UIButton*)sender{
    [[SOSoundBoxPlayer sharedPlayer] stopDLNA];
    [[SOSoundBoxPlayer sharedPlayer] startDLNA];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 16.0f : 32.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  44.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [SOSoundBoxPlayer sharedPlayer].mArrSoundboxs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FDiscoveryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FDiscoveryViewCell class])];
    [cell setMDeviceDict:[[SOSoundBoxPlayer sharedPlayer].mArrSoundboxs objectAtIndex:indexPath.row]];
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
        [_mTableView registerClass:[FDiscoveryViewCell class] forCellReuseIdentifier:NSStringFromClass([FDiscoveryViewCell class])];
        
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
