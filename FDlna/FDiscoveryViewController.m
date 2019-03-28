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
#import "SOWaterWaveView.h"
#import <YYKit.h>
#import <MJRefresh.h>
@interface FDiscoveryViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong)  NSArray *mSourceDatas;
@property (nonatomic,strong) SOWaterWaveView *waveView;
@property (nonatomic, assign) CGFloat mHeaderViewHeight;
@property (nonatomic, strong) MJRefreshNormalHeader *mHeader;
@property (nonatomic, strong) NSTimer  *mTimer;
@property (nonatomic, assign) NSInteger  mCount;
@end

@implementation FDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mCount = 10;
    self.mHeaderViewHeight = 0.1f;
    [self.mNavView setBackgroundColorClear];
    [self setTitle:@"可用设备"];
    [self.mNavView.mRightButton setTitle:@"重新查找" forState:UIControlStateNormal];
    [self.mNavView.mRightButton addTarget:self action:@selector(rightButtonAciont:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidChangeNotification:) name:kPlayerDidChangeNotificationName object:nil];
}

- (void)rightButtonAciont:(UIButton*)sender{
    [[SOSoundBoxPlayer sharedPlayer] stopDLNA];
    [[SOSoundBoxPlayer sharedPlayer] startDLNA];
}

- (void)playerDidChangeNotification:(NSNotification*)notiyf{
    [self.mTableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return CGFLOAT_MIN;
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
    if (indexPath.row < [SOSoundBoxPlayer sharedPlayer].mArrSoundboxs.count) {
        NSDictionary *dict = [SOSoundBoxSharedPlayer.mArrSoundboxs objectAtIndex:indexPath.row];
        if (![dict[kKeyDeviceUUID] isEqualToString:SOSoundBoxSharedPlayer.mCurMSRDevices[kKeyDeviceUUID]]) {
            [[SOSoundBoxPlayer sharedPlayer] setMCurMSRDevices:dict];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"ollView.contentOf: %f", scrollView.contentOffset.y);
}

- (SOWaterWaveView*)waveView{
    if (!_waveView) {
        _waveView = [[SOWaterWaveView alloc] initWithFrame:CGRectMake(0, -100, SCREEN_W, 100)];
        _waveView.backgroundColor = [UIColor grayColor];
        _waveView.backgroundColor = [UIColor redColor];
        [_waveView setFinishAnimate:^(BOOL isForce) {
        }];
    }
    return _waveView;
}


- (UITableView*)mTableView{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_H, SCREEN_W, SCREEN_H - NAVBAR_H) style:UITableViewStyleGrouped];
        _mTableView.separatorColor = _mTableView.backgroundColor;
        _mTableView.backgroundColor = [UIColor clearColor];
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        [_mTableView registerClass:[FDiscoveryViewCell class] forCellReuseIdentifier:NSStringFromClass([FDiscoveryViewCell class])];
        _mTableView.mj_header = self.mHeader;
    }
    return _mTableView;
}

- (MJRefreshNormalHeader*)mHeader{
    if (!_mHeader) {
        _mHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [[SOSoundBoxPlayer sharedPlayer] startDLNA];
            [self startTimer];
        }];
        [_mHeader setTitle:@"松开重新发现设备" forState:MJRefreshStateIdle];
        [_mHeader setTitle:@"松开重新发现设备1" forState:MJRefreshStatePulling];
        [_mHeader setTitle:@"正在查找可投放的DLNA设备..." forState:MJRefreshStateRefreshing];
        [_mHeader setTitle:@"松开重新发现设备3" forState:MJRefreshStateWillRefresh];
        [_mHeader setTitle:@"松开重新发现设备4" forState:MJRefreshStateNoMoreData];
        
        _mHeader.stateLabel.font = [UIFont systemFontOfSize:15];
        _mHeader.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
        [self.mHeader.lastUpdatedTimeLabel setText:nil];
        // 设置颜色
        _mHeader.stateLabel.textColor = [UIColor whiteColor];
        _mHeader.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
        _mHeader.automaticallyChangeAlpha = YES;
    }
    return _mHeader;
}

-(void)startTimer{
    if (!_mTimer) {
        _mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    }
}

- (void)timerAction:(NSTimer*)timer{
    NSLog(@"timerAction: %ld", (long)self.mCount);
    self.mCount --;
    if (self.mCount <= 0) {
        [self endTimer];
        self.mCount = 10;
        [self.mHeader endRefreshing];
    }
    else{
        [self.mHeader.lastUpdatedTimeLabel setText:[NSString stringWithFormat:@"剩余搜索时间%ld秒", (long)self.mCount]];
    }
}

-(void)endTimer{
    [_mTimer invalidate];
    _mTimer = nil;
}

@end
