//
//  SOSoundBoxPlayer.m
//  FDlna
//
//  Created by GaoAng on 2019/3/22.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import "SOSoundBoxPlayer.h"
#import "SHDMRControl.h"
#import "SOTools.h"
static NSInteger const MaxPlalistCount = 200;
static NSInteger const   playIndex = 50;//防止歌单超过最大后 无法添加，默认前面50首 后面150首的空余
static NSString * const KProcessTimerName = @"processTimerName";
NSString *const kPlayerDidChangeNotificationName = @"kPlayerDidChangeNotificationName";

@interface SOSoundBoxPlayer ()
<SHDMRProtocolDelegate>

@property (nonatomic, strong) SHDMRControl *mDMRCountrol;

@property (nonatomic, strong) NSMutableArray *mArrSoundboxs;//需要播放的音箱设备。
@property (nonatomic, strong) id  mMediatServerDevice;//本机当做媒体服务器。deviceUUID 是真实设备ID
@property (nonatomic, copy)     NSString *ServerName;

@property (nonatomic, strong) NSMutableArray *mArrCanPlaySoundBox;//通过DLNA搜索到且可播放的音箱设备。

@property (nonatomic, assign) BOOL  isOnlinePlaying;// 在线or 本地。
@property (nonatomic) NSMutableArray *mArrSongList;
@property (nonatomic, copy) NSString *mCurSongUrl;

@property (nonatomic, copy) actionResultBlock setVolumeResult;
@property (nonatomic, copy) void(^getVolumeResult)(SHGetVolumResponse *response);

@property (nonatomic, copy) actionResultBlock setProgressResult;
@property (nonatomic, copy) void(^getProgressResult)(SHPositionInfoResponse *response);
@property (nonatomic, assign) EPlayStatues  currentStatus;


@property (nonatomic, copy) void(^deviceCapabilities)(SHDeviceCapabilitiesResponse *response);


@property (nonatomic, copy) actionResultBlock setMuteResult;
//@property (nonatomic, copy) void(^getProgressResult)(SHPositionInfoResponse *response);

@property (nonatomic, copy) void(^getCurMediaInfo)(SHMediaInfoResponse *response);

@property (nonatomic, assign)   NSInteger  voluneFlag; //防止多次设置音量过程
//@property (nonatomic, assign)  NSTimeInterval  processFlag; //防止多次设置进度
@property (nonatomic, assign)  NSInteger  mCurSeek; //防止多次设置进度
@property (strong, nonatomic) NSLock *lock;

@end

@implementation SOSoundBoxPlayer

#pragma mark - initial

+ (instancetype)sharedPlayer {
    static SOSoundBoxPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[SOSoundBoxPlayer alloc] init];
    });
    
    return player;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ServerName = [[[NSUUID UUID] UUIDString] substringToIndex:12];
        _mArrSongList = [NSMutableArray new];
        _mDMRCountrol = [[SHDMRControl alloc] init];
        [_mDMRCountrol setDelegate:self];
        _lock = [[NSLock alloc] init];
        self.voluneFlag = STATUES_setVolumeSuccess;//默认设置成功。
        //        self.processFlag = STATUES_setProcessSuccess;//默认设置成功。
        [self addObserver:self forKeyPath:@"mArrCanPlaySoundBox" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        //先发送一个通知 告知 离线。
        [self SendPlayerEventBlockWithEvent: STATUES_canPlaySoundBoxCount eventData:@(self.mArrCanPlaySoundBox.count)];
        
        
        
    }
    return self;
}

#pragma mark - Getters & Setters

- (NSMutableArray*)mArrSoundboxs {
    if (!_mArrSoundboxs) {
        _mArrSoundboxs = [[NSMutableArray alloc] init];
    }
    return _mArrSoundboxs;
}

- (NSMutableArray*)mArrCanPlaySoundBox {
    if (!_mArrCanPlaySoundBox) {
        _mArrCanPlaySoundBox = [[NSMutableArray alloc] init];
    }
    return _mArrCanPlaySoundBox;
    
}


- (void)setCurrentItem:(id)item {
    _currentItem = item;
    [self playMusic:item];
}

#pragma mark  - 内部功能函数。
-(BOOL)isSameToCurMeida:(SHMediaInfoResponse*)response{
    if ([_mCurSongUrl isEqualToString:response.cur_uri]) {
        return YES;
    }
    return NO;
}

-(NSString*)getCurrentRenderUUID{
    id device = [_mDMRCountrol getCurrentRender];
    return nil;
}

-(NSString*)deviceUUIDwithrenderUUID:(NSString*)uuid{
    
    for (NSInteger i = 0; i < self.mArrCanPlaySoundBox.count; i++) {
    }
    return nil;
}

- (NSString *)URLEncodedString:(NSString *)str {
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

- (NSString *)getLocalUrlWithMeidaItem:(MPMediaItem *)item {
    if (![item isKindOfClass:[MPMediaItem class]]) return nil;
    
//    SHDeviceModel *deviceModel = [_mDMRCountrol getCurrentServer];
    NSString *baseUrl = nil;
//    NSString *baseUrl = deviceModel.attribute[kKeyDLNAMSUrl];
    if (baseUrl.length == 0) return nil;
    
    NSURL *assetURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
    NSString *itemUrl = assetURL.absoluteString;
    itemUrl = [self URLEncodedString:itemUrl];
    
    NSMutableString * destUrl = [[NSMutableString alloc] initWithString:baseUrl];
    [destUrl appendString:@"%25/"];
    [destUrl appendString:itemUrl];
    
    return destUrl;
}

- (NSString*)transformMusicItemToUrlstrling:(id)musicData{
    NSString *songurl = nil;
    if ([musicData isKindOfClass:[MPMediaItem class]]) {
        songurl =  [self getLocalUrlWithMeidaItem:musicData];
    }
    else if ([musicData isKindOfClass:[NSString class]]){
        songurl = musicData;
    }
    return songurl;
}

- (void)playMusic:(id)musicData {
    self.mCurSongUrl = [self transformMusicItemToUrlstrling:musicData];
    if ([musicData isKindOfClass:[MPMediaItem class]]) {
        MPMediaItem *song = (MPMediaItem*)musicData;
        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
    }
    if (_mCurSongUrl.length <= 0) {
        return;
    }
    
    [self SendPlayerEventBlockWithEvent:STATUES_WaitingToPlay
                              eventData:nil];
    
    
    self.currentStatus = PLAY_WaitingToPlay;
    if ([musicData isKindOfClass:[MPMediaItem class]]) {
        self.isOnlinePlaying = NO;
        //本地播放需要 手机做为媒体服务器
        if (![self.mMediatServerDevice isKindOfClass:[self class]]) {
            [_mDMRCountrol intendStartItunesMusicServerWithServerName:self.ServerName]; //重新创建
            [_mDMRCountrol start];
            [self SendPlayerEventBlockWithEvent:STATUES_LocationPlayNoServer
                                      eventData:nil];
        }
        else{
//            [_mDMRCountrol chooseServerWithUUID:self.mMediatServerDevice.deviceUUID];
            [self renderPlay:_mCurSongUrl isOnlinePlay:self.isOnlinePlaying];
        }
    }
    else if ([musicData isKindOfClass:[NSString class]]) {
        self.isOnlinePlaying = YES;
        [self renderPlay:_mCurSongUrl isOnlinePlay:self.isOnlinePlaying];
    }
}

- (void)setNextSongToPlay {
    NSInteger index = [_mArrSongList indexOfObject:_currentItem];
    if ( index+1 < _mArrSongList.count) {
        id nextItem = _mArrSongList[index+1];
        [_mDMRCountrol setRendererNextAVTransportURI:[self getLocalUrlWithMeidaItem:nextItem]];
    }
}

- (void)SendPlayerEventBlockWithEvent:(EEventStatues)event eventData:(id)Data {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"kEventStatues":@(event)}];
    if (Data) {
        [dictionary setValue:Data forKey:@"kEventStatues"];
    }
    NSString *deviceUUID = [self getCurrentRenderUUID];
    if (deviceUUID.length > 0) {
        [dictionary setValue:deviceUUID forKey:@"kKeyDeviceUUID"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlayerDidChangeNotificationName object:dictionary];
    });
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"mArrCanPlaySoundBox"])
    {
        [self SendPlayerEventBlockWithEvent: STATUES_canPlaySoundBoxCount eventData:@(self.mArrCanPlaySoundBox.count)];
    }
}


#pragma mark -  状态支持
-(BOOL)soundBoxCanPlaySong{
    if (self.mArrCanPlaySoundBox.count <= 0) {
        return NO;
    }
    return YES;
}

-(BOOL)soundBoxIsFoundWithDevUUid:(NSString*)deviceUUID{
    if (![deviceUUID isKindOfClass:[NSString class]] ) {
        return NO;
    }
    
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"SELF.deviceUUID == %@", deviceUUID];
    NSArray *arr = [self.mArrCanPlaySoundBox filteredArrayUsingPredicate:predict];
    if (arr.count) {
        return YES;
    }
    return NO;
}




- (EPlayStatues)playerStatus {
    return self.currentStatus;
}

- (void)startDLNA{
    [_mDMRCountrol intendStartItunesMusicServerWithServerName:self.ServerName]; //        //创建本地服务器。
    [_mDMRCountrol setDelegate:self];
    [_mDMRCountrol start]; //开启搜索 搜索附件的  渲染器 和 服务器。
}

- (void)stopDLNA{
    [self removeObserver:self forKeyPath:@"mArrCanPlaySoundBox"];
    [self.mArrCanPlaySoundBox removeAllObjects];
    _mArrCanPlaySoundBox = nil;
    [self.mArrSongList removeAllObjects];
    _mArrSongList = nil;
    [self.mArrSoundboxs removeAllObjects];
    _mArrSoundboxs = nil;
    
    [_mDMRCountrol stop];
}
-(NSString*)getCurItemTitle{
    NSString *songTitle = nil;
    
    if ([_currentItem isKindOfClass:[MPMediaItem class]]){
//        MPMediaItem *model = (MPMediaItem*)SoundBoxSharedPlayer.currentItem;
//        songTitle = [model valueForProperty: MPMediaItemPropertyTitle];
        
    }
    return songTitle;
}
#pragma mark - 播放相关功能
- (void)insertSongItemToPlayList:(id)song{
    if (song) {
        [self insertSongsToPlayList:@[song]];
    }
}

- (void)insertSongsToPlayList:(NSArray *)songs {
    if (songs.count == 0) {
        return;
    }
    
    NSInteger currentIndex =0;
    if (_currentItem == nil) {
        currentIndex = 0;
    }
    else{
        currentIndex = [self.mArrSongList indexOfObject:_currentItem];
        if (currentIndex == NSNotFound) {
            currentIndex = 0;
        }
    }
    
    [_lock lock];
    NSIndexSet *helpIndex = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(currentIndex, [songs count])];
    if (songs.count == helpIndex.count) {
        [self.mArrSongList insertObjects:songs atIndexes:helpIndex];
    }
    //先插入后删除超过最大的数据。保持两百首。。。插入后自动删除超过限制的歌曲
    if (self.mArrSongList.count > MaxPlalistCount) {
        [self.mArrSongList removeObjectsInRange:NSMakeRange(MaxPlalistCount-1, self.mArrSongList.count - MaxPlalistCount)];
    }
    [_lock unlock];
    
    self.currentItem = songs.firstObject; //触发播放。
}

- (void)resumeMusicWithSeek {
    if (_currentItem) {
        //        if (self.currentStatus == PLAY_pasue) {
        //            self.currentStatus = PLAY_pasue;
        [_mDMRCountrol renderPlay];
        [self setProgress:self.mCurSeek WithResult:nil];
        //        }
    }
}
- (void)resumeMusic{
    if (_currentItem) {
        [_mDMRCountrol renderPlay];
    }
}

// 播放
- (void)renderPlay:(NSString *)url isOnlinePlay:(BOOL)isOnlinePlay{
    //没有可播放的设备 重新搜索播放。
    if (self.mArrCanPlaySoundBox.count <= 0) {
        [_mDMRCountrol start];
        [self SendPlayerEventBlockWithEvent:STATUES_NoPlayDevice eventData:nil];
        return;
    }
    //    self.playStatue = PLAY_playing;
    //同时播放可播放的设备。
    for (NSInteger i = 0; i < self.mArrCanPlaySoundBox.count; i++) {
//        SHDeviceModel *model = self.mArrCanPlaySoundBox[i];
//        [_mDMRCountrol chooseRenderWithUUID:model.attribute[kKeyAudioUuid]];
//        NSInteger  success =  [_mDMRCountrol renderSetAVTransportWithURI:url metaData:nil];
        NSInteger success =  [_mDMRCountrol renderPlay];
        [self SendPlayerEventBlockWithEvent:success == 0 ? STATUES_playCtrlSendSuccess:STATUES_playCtrlSendFaild
                                  eventData:nil];
    }
}

-(void)setAVTransponrtResponse:(SHEventResultResponse *)response{
}


-(void)playResponse:(SHEventResultResponse *)response{
    [self SendPlayerEventBlockWithEvent: response.result == 0 ? STATUES_playResponseSuccess :  STATUES_playResponseFaild
                              eventData:nil];
}


#pragma mark - 暂停播放
- (void)pausePlayerWithSeek:(NSInteger)seek{
    if (self.currentStatus == PLAY_playing) {
        self.mCurSeek = seek;
        for (NSInteger i = 0; i < self.mArrCanPlaySoundBox.count; i++) {
//            SHDeviceModel *model = self.mArrCanPlaySoundBox[i];
//            [_mDMRCountrol  chooseRenderWithUUID:model.attribute[kKeyAudioUuid]];
//            NSInteger  success =  [_mDMRCountrol renderPause];
//            SHLogInfo(kLogModuleDaVoiceBox, @"播放音乐暂停 指令发送 : %@ %d",success == 0 ?@"success":@"faild",success);
//            [self SendPlayerEventBlockWithEvent: success == 0 ?STATUES_pauseCtrlSendSuccess:STATUES_pauseCtrlSendFaild
//                                      eventData:nil];
        }
    }
    else{
        [self SendPlayerEventBlockWithEvent:STATUES_pauseNoNeed
                                  eventData:nil];
    }
    
    self.currentStatus = PLAY_pasue;
}

-(void)pausePlayer{
    if (self.currentStatus == PLAY_playing) {
        for (NSInteger i = 0; i < self.mArrCanPlaySoundBox.count; i++) {
//            SHDeviceModel *model = self.mArrCanPlaySoundBox[i];
//            [_mDMRCountrol  chooseRenderWithUUID:model.attribute[kKeyAudioUuid]];
//            NSInteger  success =  [_mDMRCountrol renderPause];
//            SHLogInfo(kLogModuleDaVoiceBox, @"播放音乐暂停 指令发送 : %@ %d",success == 0 ?@"success":@"faild",success);
//            [self SendPlayerEventBlockWithEvent: success == 0 ?STATUES_pauseCtrlSendSuccess:STATUES_pauseCtrlSendFaild
//                                      eventData:nil];
        }
    }
    else{
        [self SendPlayerEventBlockWithEvent:STATUES_pauseNoNeed
                                  eventData:nil];
    }
    self.currentStatus = PLAY_pasue;
}

-(void)pasuseResponse:(SHEventResultResponse *)response{
    
    [self SendPlayerEventBlockWithEvent:response.result == 0 ? STATUES_pauseResponseSuccess : STATUES_pauseResponseFaild
                              eventData:nil];
}


#pragma mark - 停止播放。
// 播放停止
-(void)stopPlayer{
    if (self.currentStatus == PLAY_playing) {
        for (NSInteger i = 0; i < self.mArrCanPlaySoundBox.count; i++) {
//            SHDeviceModel *model = self.mArrCanPlaySoundBox[i];
//            [_mDMRCountrol chooseRenderWithUUID:model.attribute[kKeyAudioUuid]];
            int success =  [_mDMRCountrol renderStop];
            [self SendPlayerEventBlockWithEvent: success ? STATUES_stopCtrlSendSuccess: STATUES_stopCtrlSendFaild
                                      eventData:nil];
            
        }
    }
    else{
        [self SendPlayerEventBlockWithEvent:STATUES_stopNoNeed
                                  eventData:nil];
    }
    
    self.currentStatus = PLAY_stop;
}

-(void)stopResponse:(SHEventResultResponse *)response{
    [self SendPlayerEventBlockWithEvent: response.result == 0 ? STATUES_stopResponseSuccess :  STATUES_stopResponseFaild
                              eventData:nil];
    
}

#pragma mark  - 设置音量
// 设置音量
- (void)setVolume:(int)volume WithResult:(actionResultBlock)setVolumeResult{
    _setVolumeResult = setVolumeResult;
    for (NSInteger i = 0; i < self.mArrCanPlaySoundBox.count; i++) {
//        SHDeviceModel *model = self.mArrCanPlaySoundBox[i];
//        [_mDMRCountrol  chooseRenderWithUUID:model.attribute[kKeyAudioUuid]];
        NSTimeInterval flag = [SOTools milliSecondTimestamp];
        NSInteger success =   [_mDMRCountrol renderSetVolume:volume withUserData:@(flag)];
        if (success == 0) {
            self.voluneFlag ++;
        }
    }
}
-(void)setVolumeResponse:(SHEventResultResponse *)response{
    if ([response.userData integerValue] >= self.voluneFlag) {
        //        self.voluneFlag = STATUES_setVolumeSuccess;
        if (_setVolumeResult) {
            _setVolumeResult([self deviceUUIDwithrenderUUID:response.deviceUUID], response.result);
        }
    }
}

// 获取当前音量
- (void)getVolume:(void(^)(SHGetVolumResponse *response))getVolumeResult{
    _getVolumeResult = getVolumeResult;
    int success = [_mDMRCountrol renderGetVolume];
    
}

-(void)getVolumeResponse:(SHGetVolumResponse *)response{
    if (_getVolumeResult) {
        _getVolumeResult(response);
    }
}
// 设置静音
- (void)setMute:(BOOL)mute WithResult:(actionResultBlock)setVolumeResult{
    int success = 0;
    if (mute) {
        success = [_mDMRCountrol setRenderMute];
    }
    else{
        success = [_mDMRCountrol setRenderUnMute];
    }
    
}

-(void)setMuteResponse:(SHEventResultResponse *)response{
    if (_setMuteResult) {
        _setMuteResult([self deviceUUIDwithrenderUUID:response.deviceUUID], response.result);
    }
}

#pragma mark - 进度 -- 开启定时器定时查询上报。
-(void)startPrcessTimerWithMaxTime:(NSTimeInterval)timeout{
//    [TimerManager startCountdownTimerWithTimeout:0 timeStep:1 timerName:KProcessTimerName waiting:^(NSTimeInterval leftInterval) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self getProgress:^(SHPositionInfoResponse *response) {
//                if ([response isKindOfClass:[SHPositionInfoResponse class]]) {
//                    [self SendPlayerEventBlockWithEvent:STATUES_ProcessStatueChange
//                                              eventData:response];
//                }
//            }];
//        });
//    } completion:nil];
}

//-(void)resumeProgressTimer{
//    [TimerManager resumeTimerWithName:KProcessTimerName];
//}
//
//-(void)suspendProgressTimer{
//    [TimerManager suspendTimerWithName:KProcessTimerName];
//}
//
//-(void)stopProgressTimer{
//    [TimerManager cancelTimerWithName:KProcessTimerName];
//}


//设置进度。。。。暂停进度查询
-(void)beginSliderProgress{
//    [self suspendProgressTimer];
}

- (void)setProgress:(NSInteger)seconds WithResult:(actionResultBlock)setProgressResult{
    _setProgressResult =setProgressResult;
    NSTimeInterval flag = [SOTools milliSecondTimestamp];
    int success = [_mDMRCountrol seekAudio:seconds withUserData:@(flag)];
    if (success == 0) {
        //        self.processFlag = flag;
    }
    else{
//        [self resumeProgressTimer];
    }
    self.currentStatus = PLAY_seeking;
}

-(void)OnSeekResult:(SHEventResultResponse *)response{
    if (_setProgressResult) {
        _setProgressResult([self deviceUUIDwithrenderUUID:response.deviceUUID], response.result);
    }
    //    }
}

//获取播放进度。
- (void)getProgress:(void(^)(SHPositionInfoResponse *response))getProgressResult{
    if (self.currentStatus == PLAY_seeking) {
        return;
    }
    
    _getProgressResult = getProgressResult;
    int success = 0;
    success = [_mDMRCountrol getRendererPositionInfo];
    //    self.currentStatus = PLAY_seeking;
    //    SHLogInfo(kLogModuleDaVoiceBox, @"获取进度 指令发送 : %@ %d",success == 0 ?@"success":@"faild",success);
    
}

-(void)getPositionInfoResponse:(SHPositionInfoResponse *)response{
    //    SHLogInfo(kLogModuleDaVoiceBox, @"%@ %d",(response.result == 0 ?@"success":@"faild"),response.result);
    if (_getProgressResult) {
        _getProgressResult(response);
    }
}

//获取当前播放的媒体信息
-(void)getCurMediaInfo:(void (^)(SHMediaInfoResponse *))getCurMediaInfo{
    _getCurMediaInfo = getCurMediaInfo;
    int success = [_mDMRCountrol getRendererMediaInfo];
}

-(void)OnGetMediaInfoResult:(SHMediaInfoResponse *)response{
    if (_getCurMediaInfo) {
        _getCurMediaInfo(response);
    }
}

- (void)getRendererDeviceCapabilities:(void(^)(SHDeviceCapabilitiesResponse *response))deviceCapabilities{
    _deviceCapabilities = deviceCapabilities;
    int success = [_mDMRCountrol getRendererDeviceCapabilities];
}

-(void)OnGetDeviceCapabilitiesResult:(SHDeviceCapabilitiesResponse *)response{
    if (_deviceCapabilities) {
        _deviceCapabilities(response);
    }
}


#pragma mark - 上一首 下一首
-(BOOL)canPlayPreSong{
    if ([_mArrSongList containsObject:_currentItem]) {
        NSInteger index = [self.mArrSongList indexOfObject:_currentItem];
        if (index == 0) {
            return NO;
        }
        return YES;
    }
    return NO;
}

-(void)playPreSong{
    if ([_mArrSongList containsObject:_currentItem]) {
        NSInteger index = [self.mArrSongList indexOfObject:_currentItem];
        if (index > 0) {
            self.currentItem = [self.mArrSongList objectAtIndex:index-1];//触发播放
        }
    }
    
}

-(BOOL)canPlayNextSong{
    if ([_mArrSongList containsObject:_currentItem]) {
        NSInteger index = [self.mArrSongList indexOfObject:_currentItem];
        if (index  != self.mArrSongList.count -1) {
            return YES;
        }
    }
    return NO;
}

-(void)playNextSong{
    if ([_mArrSongList containsObject:_currentItem]) {
        NSInteger index = [self.mArrSongList indexOfObject:_currentItem];
        if (index  < self.mArrSongList.count - 1) {
            self.currentItem = [self.mArrSongList objectAtIndex:index + 1];//触发播放
        }
    }
}


#pragma mark - 搜索服务设备 。。
-(void)OnMSAdded{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *arrActiveServers = [_mDMRCountrol getActiveServers];
        for (NSInteger i = 0 ; i < arrActiveServers.count; i ++) {
//            SHDeviceModel *tempDevice = arrActiveServers[i];
//
//            //判断是自己的手机服务器
//            if ([tempDevice.deviceName containsString:weakself.ServerName]) {
//                SHDeviceModel *curDevice = [_mDMRCountrol getCurrentServer];
//                if (![curDevice.deviceUUID isEqualToString:tempDevice.deviceUUID]) {
//                    [_mDMRCountrol chooseServerWithUUID:tempDevice.deviceUUID];
//                    weakself.mMediatServerDevice = tempDevice;
//                }
//                else{
//                    weakself.mMediatServerDevice = curDevice;
//                }
//
//                //
//                if ([weakself.mMediatServerDevice isKindOfClass:[SHDeviceModel class]]) {
//                    SHLogInfo(kLogModuleDaInterComm, @"发现可播放服务器:%@, %@", weakself.mMediatServerDevice.deviceUUID, weakself.mMediatServerDevice.deviceName);
//                    if (weakself.currentStatus == PLAY_WaitingToPlay) {
//                        [weakself playMusic:weakself.currentItem];
//                    }
//                }
//
//                break;
//            }
//
        }
    });
}

-(void)OnMSRemoved:(NSString *)deviceUUID{
//    if ([self.mMediatServerDevice.deviceUUID isEqualToString:deviceUUID]) {
//        self.mMediatServerDevice = nil;
//    }
}


#pragma mark -  SHDMRProtocolDelegate  可播放设备搜索结果。。。
-(void)onDMRAdded{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *arrActiveRenders = [_mDMRCountrol getActiveRenders];
    });
}

-(void)onDMRRemoved:(NSString *)deviceUUID{
    for (NSInteger i = self.mArrCanPlaySoundBox.count -1; i >= 0; i--) {
    }
}

-(void)DMRStateViriablesChanged:(NSArray<SHEventParamsResponse *> *)response{
    for (SHEventParamsResponse *paramsResponse in response) {
        //音量变化
        if ([paramsResponse.eventName isEqualToString:@"Volume"]){
            self.voluneFlag -- ;
            if (self.voluneFlag <= STATUES_setVolumeSuccess) {
                self.voluneFlag = STATUES_setVolumeSuccess;
                [self SendPlayerEventBlockWithEvent:STATUES_VolumeStatueChange
                                          eventData:@([paramsResponse.eventValue integerValue])];
            }
        }
        //开始播放
        else if ([paramsResponse.eventName isEqualToString:@"TransportState"] &&
                 [paramsResponse.eventValue isEqualToString:@"PLAYING"]
                 ){
            if (self.currentStatus == PLAY_WaitingToPlay ||
                self.currentStatus == PLAY_pasue ||
                self.currentStatus == PLAY_playing ||
                self.currentStatus == PLAY_seeking) {
                
                self.currentStatus = PLAY_playing;//正在播放。。。
                [self setNextSongToPlay];//预先设置下首歌曲的播放。不走stop 状态
                [self startPrcessTimerWithMaxTime:0]; //开启播放进度上报定时器。
                
                //                [self SendPlayerEventBlockWithEvent:STATUES_Playing
                //                                          eventData:nil];
                
                // 播放后自动校正当前播放的数据。
                [self getCurMediaInfo:^(SHMediaInfoResponse *response) {
                    for (NSInteger i = 0; i < self.mArrSongList.count; i ++) {
                        id songData = self.mArrSongList[i];
                        if ([response.cur_uri isEqualToString:[self transformMusicItemToUrlstrling:songData]]) {
                            _currentItem = songData;
                            [self SendPlayerEventBlockWithEvent:STATUES_Playing
                                                      eventData:nil];
                            
                        }
                    }
                }];
                
            }
            
        }
        //暂停播放
        else if ([paramsResponse.eventName isEqualToString:@"TransportState"] &&
                 [paramsResponse.eventValue isEqualToString:@"PAUSED_PLAYBACK"]
                 ){
            //            [self suspendTimer]; //暂停定时器。
            self.currentStatus = PLAY_pasue;
            [self SendPlayerEventBlockWithEvent:STATUES_pause
                                      eventData:nil];
        }
        //停止播放。
        else if ([paramsResponse.eventName isEqualToString:@"TransportState"] &&
                 [paramsResponse.eventValue isEqualToString:@"STOPPED"]
                 ){
//            [self stopProgressTimer]; //关闭播放进度上报定时器。
            //还没播放就停止了。
            if (self.currentStatus == PLAY_WaitingToPlay || self.currentStatus == PLAY_seeking) {
                //                    [self playMusic:_currentItem];  不在继续播放当前歌曲。
                [self SendPlayerEventBlockWithEvent:STATUES_playFailed
                                          eventData:nil];
            }
            //正常播放停止。
            else if (self.currentStatus == PLAY_playing){
                //播放下一首。
                if ([_mArrSongList containsObject:self.currentItem]) {
                    NSInteger index = [self.mArrSongList indexOfObject:_currentItem];
                    //已经是最后一首歌曲。
                    if (_mArrSongList.count - 1 == index) {
                        self.currentStatus = PLAY_init;//播
                        self.currentItem = nil; //可能为空。。。
                        [self SendPlayerEventBlockWithEvent:STATUES_PlayStopped
                                                  eventData:nil];
                    }
                    //删除排在第一个的歌曲。
                    else{
                        self.currentItem = [_mArrSongList objectAtIndex:index + 1];//触发播放。
                        //                            [self.mArrSongList removeObjectAtIndex:0];
                        if (index > playIndex) {
                            [_lock lock];
                            [self.mArrSongList removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, index - playIndex)]];
                            [_lock unlock];
                        }
                        [self SendPlayerEventBlockWithEvent:STATUES_playNextSong eventData:self.currentItem];
                        
                    }
                }
                else{
                }
            }
        }
    }
}

@end
