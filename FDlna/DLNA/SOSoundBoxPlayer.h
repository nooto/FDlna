//
//  SOSoundBoxPlayer.h
//  FDlna
//
//  Created by GaoAng on 2019/3/22.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MPMediaItem.h>
#import "SHEventParamsResponse.h"

extern NSString *const kPlayerDidChangeNotificationName;

typedef void(^actionResultBlock)(NSString *uuid, NSInteger result);

typedef NS_ENUM(NSInteger, EPlayEvent) {
    EVENT_PlayAction,               // 播放动作
    EVENT_PauseAction,
    EVENT_StopAction,

    EVENT_SetVolumeAction,          // 设置音量
    EVENT_GetVolumeAction,

    EVENT_SetProgressAction,        // 设置进度
    EVENT_GetProgressAction,

//    EVENT_StatueChange              // 状态变化通知
    EVENT_PlayStatueChange,              //播放状态
    EVENT_VolumStatueChange,              // 音量状态
    EVENT_ProcessStatueChange,              //进度状态

    EVENT_Other     //  栅栏状态    不使用

};

typedef NS_ENUM(NSInteger, EEventStatues) {
    STATUES_LocationPlayNoServer = 10001,       // 本地播放没找到媒体服务器，进行重建服务器，并重新搜索DLNA 设备&服务器
    STATUES_NoPlayDevice,            // 本地播放没有找到可播放的音箱
    //    STATUES_OnlinePlayNoPlayDevice,             // 在线播放没有找到可播放的音箱
    
    //播放流程--》 设置发指令--音箱反馈--传送--播放
    STATUES_WaitingToPlay, //等待播放
    
    STATUES_playCtrlSendSuccess,                // 发送播放指令成功
    STATUES_playCtrlSendFaild,                  // 发送播放指令失败
    
    STATUES_playResponseSuccess,                  // 发送播放指令失败
    STATUES_playResponseFaild,                  // 发送播放指令失败
    
    //暂停流程
    STATUES_pauseNoNeed,                        // 当前非播放状态无需发送暂停指令
    STATUES_pauseCtrlSendSuccess,                      // 发送暂停指令成功
    STATUES_pauseCtrlSendFaild,                      // 发送暂停指令失败
    
    STATUES_pauseResponseSuccess,                  //音箱设备反馈成功
    STATUES_pauseResponseFaild,                  // 音箱设备反馈暂停失败
    
    
    //停止流程
    STATUES_stopNoNeed,                         // 当前非播放状态无需发送停止指令
    STATUES_stopCtrlSendSuccess,                      // 发送停止指令成功
    STATUES_stopCtrlSendFaild,                      // 发送停止指令失败
    
    STATUES_stopResponseSuccess,                  //音箱设备反馈停止成功
    STATUES_stopResponseFaild,                  // 音箱设备反馈停止失败
    
    //设置音量
    STATUES_setVolumeCtrlSend,                  // 发送设置音量指令
    STATUES_setVolumeSuccess,                   // 设置音量成功
    STATUES_setVolumeFailed,                    // 设置音量失败
    STATUES_VolumeStatueChange,                    // 设置音量失败
    
    //设置进度
    STATUES_setProcessCtrlSend,                  // 发送进度发送成功
    STATUES_setProcessSuccess,                   // 设置进度成功
    STATUES_setProcessFailed,                    // 设置进度失败
    STATUES_ProcessStatueChange,                    //进度自动上报
    
    //其他数据。
    STATUES_playListIsNull,                     // 播放列表中没有歌曲
    STATUES_playNextSong,                        // 开始播放下一首歌曲。
    
    STATUES_playFailed,                        // 播放失败
    //音箱状态
    STATUES_Playing,  //正在播放
    STATUES_pause,  //暂停播放
    STATUES_PlayStopped,  //停止播放
    
    STATUES_canPlaySoundBoxCount,  //当前可播放音箱的数量  0：不可播放   1...n:可播放设备个数。
    
    //
    STATUES_Other     //  栅栏状态    不使用
};

typedef NS_ENUM(NSInteger, EPlayStatues){
    PLAY_init = 0,  //初始状态
    PLAY_Ready,  //准备播放
    PLAY_WaitingToPlay, //等待播放
    PLAY_playing,
    PLAY_seeking,  //正在设置进度
    PLAY_pasue,
    PLAY_stop
};

#define SOSoundBoxSharedPlayer [SOSoundBoxPlayer sharedPlayer]

@interface SOSoundBoxPlayer : NSObject

@property (nonatomic,strong, readonly) NSMutableArray *mArrSongList;

@property (nonatomic, strong, readonly) NSDictionary *mCurMSRDevices;//当前正在播放的设备。
@property (nonatomic, strong) id currentItem;   // 当前播放正在播放的东西，这里还要根据实际情况去修改  可能是空。

@property (nonatomic, strong, readonly) NSMutableArray *mArrSoundboxs;//需要播放的音箱设备。

/**
 所有事件上报通知。
 event: 事件类型。
 statues： 状态数据  结合EEventStatues和 设备上报的状态量
 */
//@property (nonatomic, copy) void(^playerEventBlock)(EPlayEvent event, id statues);
@property (nonatomic, assign, readonly) EPlayStatues  playerStatus;  //是不是在播放
+ (instancetype)sharedPlayer;

-(NSString*)getCurItemTitle;

- (void)setMCurMSRDevices:(NSDictionary*)dict;
-(BOOL)isSameToCurMeida:(MPMediaItem*)mediaItem;

- (void)startDLNA;
- (void)stopDLNA;

- (void)playMusic:(MPMediaItem*)mediaItem;


- (void)insertSongItemToPlayList:(id)song; //自动触发播放第一首音乐
- (void)insertSongsToPlayList:(NSArray *)songs; //自动触发播放第一首音乐

- (void)resumeMusicWithSeek; // 暂停后继续播放当前音乐
- (void)pausePlayerWithSeek:(NSInteger)seek;

- (void)resumeMusic;
- (void)pausePlayer;//暂停播放。

- (void)stopPlayer;


-(BOOL)canPlayPreSong;
-(void)playPreSong;
-(BOOL)canPlayNextSong;
-(void)playNextSong;

// 设置音量
- (void)setVolume:(int)volume WithResult:(actionResultBlock)setVolumeResult;

// 获取当前音量
- (void)getVolume:(void(^)(SHGetVolumResponse *response))getVolumeResult;

// 设置静音 取消静音
- (void)setMute:(BOOL)mute WithResult:(actionResultBlock)setVolumeResult;


//设置播放进度。
- (void)setProgress:(NSInteger)seconds WithResult:(actionResultBlock)seekResult;

//获取播放进度。
- (void)getProgress:(void(^)(SHPositionInfoResponse *response))getProgressResult;


- (void)getCurMediaInfo:(void(^)(SHMediaInfoResponse *response))getCurMediaInfo;

- (void)getRendererDeviceCapabilities:(void(^)(SHDeviceCapabilitiesResponse *response))deviceCapabilities;

@end






