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
#import "FMainEmptyView.h"
#import <StepOHelper.h>
#import "FHelpViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface FDiscoveryViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong)  NSArray *mSourceDatas;
@property (nonatomic,strong) SOWaterWaveView *waveView;
@property (nonatomic, assign) CGFloat mHeaderViewHeight;
@property (nonatomic, strong) MJRefreshNormalHeader *mHeader;
@property (nonatomic, strong) NSTimer  *mTimer;
@property (nonatomic, assign) NSInteger  mCount;
@property (nonatomic, strong) FMainEmptyView *mEmptyView;

@property (nonatomic, strong) CLLocationManager *locationMagager;

@end

@implementation FDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mCount = 10;
    self.mHeaderViewHeight = 0.1f;
    [self.mNavView setBackgroundColorClear];
    [self.mNavView setTitle:@"可播放设备"];
    [self.mNavView.mRightButton setImage:[UIImage imageNamed:@"icn_info"] forState:UIControlStateNormal];
    [self.mNavView.mRightButton setTitle:nil forState:UIControlStateNormal];
    [self.mNavView.mRightButton addTarget:self action:@selector(rightButtonAciont:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mTableView];
    self.mEmptyView.hidden = [SOSoundBoxPlayer sharedPlayer].mArrSoundboxs.count ? YES:NO;
    [self.mTableView setBackgroundView:self.mEmptyView];
    [self checkWiFI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidChangeNotification:) name:kPlayerDidChangeNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (CLLocationManager *)locationMagager {
    if (!_locationMagager) {
        _locationMagager = [[CLLocationManager alloc] init];
        _locationMagager.delegate = self;
    }
    return _locationMagager;
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)rightButtonAciont:(UIButton*)sender{
    FHelpViewController *helpVC = [[FHelpViewController alloc] init];
    [self.navigationController pushViewController:helpVC animated:YES];
}

- (void)playerDidChangeNotification:(NSNotification*)notiyf{
    self.mEmptyView.hidden = [SOSoundBoxPlayer sharedPlayer].mArrSoundboxs.count ? YES:NO;
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
    NSDictionary *tempDict =[[SOSoundBoxPlayer sharedPlayer].mArrSoundboxs objectAtIndex:indexPath.row];
    [cell setMDeviceDict:tempDict isCurrentDevice:[[SOSoundBoxPlayer sharedPlayer] isSameToCurDevice:tempDict]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [SOSoundBoxPlayer sharedPlayer].mArrSoundboxs.count) {
        NSDictionary *dict = [SOSoundBoxSharedPlayer.mArrSoundboxs objectAtIndex:indexPath.row];
        if (![dict[kKeyDeviceUUID] isEqualToString:SOSoundBoxSharedPlayer.mCurMSRDevices[kKeyDeviceUUID]]) {
            [[SOSoundBoxPlayer sharedPlayer] setMCurMRDevices:dict];
            [self.mTableView reloadData];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"ollView.contentOf: %f", scrollView.contentOffset.y);
}

- (BOOL)checkWiFI{
    if (@available(iOS 13, *)) {
        if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {//开启了权限，直接搜索
            return  [self didCheckWiFI];
        } else if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusDenied) {//如果用户没给权限，则提示
            [SOAlertManagerShareInstance showAlertViewWithTitle:@"提示" message:@"请开启定位权限，搜索您附近同一局域网内的可播放设备。。。" leftButton:@"开启" rightButton:nil completct:^(NSInteger selectIndex, NSString *title) {
                       [self.locationMagager requestWhenInUseAuthorization];
                   }];
            
        } else {//请求权限
            [self.locationMagager requestWhenInUseAuthorization];
        }
        return NO;
    }
    else {
        return  [self didCheckWiFI];
    }
}


- (BOOL)didCheckWiFI{
    NSString *SSID= [UIDevice Wi_FiSSID];
    if (SSID.length == 0) {
        SSID = [UIDevice getWifiName];
        [SOAlertManagerShareInstance showAlertViewWithTitle:@"提示" message:@"需要在Wi-Fi情况下，搜索音箱设备，请连接到Wi-Fi网络后，点击屏幕搜索设备。。。" leftButton:@"去连接" rightButton:@"暂不连接" completct:^(NSInteger selectIndex, NSString *title) {
            if (selectIndex == 0) {
                [SOTools openApplicationOpenSetting];
            }
            else{
                [self.mEmptyView.titleLabel setText:@"请链接Wi-Fi后重新搜索设备..."];
            }
        }];
        return NO;
    }
    return YES;

}
#pragma mark -
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
            if ([self checkWiFI]) {
                [[SOSoundBoxPlayer sharedPlayer] startDLNA];
                [self startTimer];
            }
            else{
                [self.mTableView.mj_header endRefreshing];
            }
        }];
        [_mHeader setTitle:@"松开重新发现设备" forState:MJRefreshStateIdle];
        [_mHeader setTitle:@"松开重新发现设备" forState:MJRefreshStatePulling];
        [_mHeader setTitle:@"正在查找可投放的DLNA设备..." forState:MJRefreshStateRefreshing];
        [_mHeader setTitle:@"松开重新发现设备" forState:MJRefreshStateWillRefresh];
        [_mHeader setTitle:@"松开重新发现设备" forState:MJRefreshStateNoMoreData];
        
        _mHeader.stateLabel.font = [UIFont systemFontOfSize:14];
        _mHeader.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
        [_mHeader.lastUpdatedTimeLabel setText:nil];
        // 设置颜色
        _mHeader.stateLabel.textColor = UIColorFromHexString(@"#FFC700");
        _mHeader.lastUpdatedTimeLabel.textColor = UIColorFromHexString(@"#FFC700");
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
-(FMainEmptyView*)mEmptyView{
    if (!_mEmptyView) {
        _mEmptyView = [[FMainEmptyView alloc] initWithFrame:self.mTableView.frame];
        _mEmptyView.backgroundColor = [UIColor clearColor];
        [_mEmptyView.titleLabel setText:@"暂无音乐信息"];
        [_mEmptyView.titleLabel setTextColor:[UIColor whiteColor]];
        @weakify(self);
        [_mEmptyView setClickDefaultViewCompletion:^{
            @strongify(self);
            [self.mTableView.mj_header beginRefreshing];
        }];
    }
    return _mEmptyView;
}

- (void)applicationDidActive:(NSNotification*)notification {
    [self checkWiFI];
}

@end
