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
#import "FMainEmptyView.h"
#import <StepOHelper.h>
@interface FMainViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong)  NSArray *mSourceDatas;
@property (nonatomic, strong) FMainEmptyView *mEmptyView;
@end

@implementation FMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SOSoundBoxPlayer sharedPlayer] startDLNA];
    
    [self.mNavView setBackgroundColorClear];
    [self.mNavView setTitle:@"iTunes Music"];
    self.mNavView.mLeftButton.hidden = YES;
    [self.mNavView.mRightButton setTitle:nil forState:UIControlStateNormal];
    [self.mNavView.mRightButton setImage:[UIImage imageNamed:@"img_nodevice"] forState:UIControlStateNormal];
    [self.mNavView.mRightButton addTarget:self action:@selector(rightButtonAciont:) forControlEvents:UIControlEventTouchUpInside];
    
    [self requestLocalMusicData];
    [self.view addSubview:self.mTableView];
    [self.view addSubview:self.mEmptyView];
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
    return (indexPath.section == 0) ? 60.f : 44.f;
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
    return self.mSourceDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FMusicTableViewCell class])];
    MPMediaItem *tempItem =[self.mSourceDatas objectAtIndex:indexPath.row];
    [cell loarCellWithMediaitem:tempItem songStatus:[self getMPMeidaItemSataus:tempItem]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.mSourceDatas.count) {
        [self playMusice:[self.mSourceDatas objectAtIndex:indexPath.row]];
    }
}

-(void)playMusice:(MPMediaItem*)item{
    if ([[SOSoundBoxPlayer sharedPlayer].mCurMSRDevices isKindOfClass:[NSDictionary class]]) {
        [[SOSoundBoxPlayer sharedPlayer] playMusic:item];
    }
    else{
        SOCustomAlertView *alertView = [[SOCustomAlertView alloc] initWithTitle:@"提示" message:@"还没有可播放的设备，请先去选择一个可以播放的设备..." leftButton:@"现在去选" rightButton:@"取消"];
        alertView.isTouchBgDismiss = YES;
        [SOAlertManagerShareInstance showAlertView:alertView];
        [alertView setDidSelcectButtonAtIndexWithTitle:^(NSInteger index, NSString *buttonText) {
            if (index == 0) {
                [self rightButtonAciont:nil];
            }
        }];
    }
}

- (UITableView*)mTableView{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_H, SCREEN_W, SCREEN_H -NAVBAR_H) style:UITableViewStyleGrouped];
        _mTableView.backgroundColor = [UIColor clearColor];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _mTableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.5f];
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        [_mTableView registerClass:[FMusicTableViewCell class] forCellReuseIdentifier:NSStringFromClass([FMusicTableViewCell class])];

    }
    return _mTableView;
}

- (SOSongStatus)getMPMeidaItemSataus:(MPMediaItem*)item{
    SOSongStatus songStatus = SOSongStatu_Default;
    
    if ([SOSoundBoxPlayer sharedPlayer].playerStatus == SOSongStatu_Playing ||
        [SOSoundBoxPlayer sharedPlayer].playerStatus == SOSongStatu_Pause) {
        BOOL isCurrentSont = [[SOSoundBoxPlayer sharedPlayer] isSameToCurMeida:item];
        if (isCurrentSont) {
            songStatus = SOSongStatu_Playing;
        }
        else{
            songStatus = SOSongStatu_Pause;
        }
    }
    return songStatus;
}

- (void)requestLocalMusicData{
    [[FLocalMusicServices sharedInstance]  fetchLocalMusicAssetsWithCompletion:^(BOOL isAccess, NSArray *loacalItems) {
        if (isAccess) {
            self.mSourceDatas =  loacalItems;
            if (self.mSourceDatas.count) {
                self.mTableView.hidden = NO;
                self.mEmptyView.hidden = YES;
                [self.mTableView reloadData];
            }
            else{
                self.mTableView.hidden = YES;
                self.mEmptyView.hidden = NO;
                [self.mEmptyView.titleLabel setText:@"哇哦，您的iTunes中歌曲没有歌曲可进行投放~~~~"];
            }
        }
        else{
            self.mTableView.hidden = YES;
            self.mEmptyView.hidden = NO;
            [self.mEmptyView.titleLabel setText:@"请先允许读取iTunes中歌曲，进行投放~~~~"];
        }
    }];
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
            [self requestLocalMusicData];
        }];
    }
    return _mEmptyView;
}

@end
