//
//  SHDMRControlModel.h
//  PlatinumDemo
//
//  Created by GVS on 16/11/24.
//  Copyright © 2016年 GVS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHEventParamsResponse.h"
#import <MediaPlayer/MediaPlayer.h>

//#import "PltMicroMediaController.h"
@protocol SHDMRProtocolDelegate <NSObject>

@optional

-(void)OnMSAdded; //发现媒体渲染服务器
-(void)OnMSRemoved:(NSString*)deviceUUID;

/**
 发现并添加DMR(媒体渲染器)
 */
-(void)onDMRAdded;

/**
 移除DMR
 */
-(void)onDMRRemoved:(NSString*)deviceUUID;


/**
 无DMR被选中
 */
-(void)noDMRBeSelected;

-(void)getCurrentAVTransportActionResponse:(SHCurrentAVTransportActionResponse *)response;

-(void)getTransportInfoResponse:(SHTransportInfoResponse *)response;

-(void)previousResponse:(SHEventResultResponse *)response;

-(void)nextResponse:(SHEventResultResponse *)response;

-(void)DMRStateViriablesChanged:(NSArray <SHEventParamsResponse *> *)response;

-(void)playResponse:(SHEventResultResponse *)response;

-(void)pasuseResponse:(SHEventResultResponse *)response;

-(void)stopResponse:(SHEventResultResponse *)response;

-(void)setAVTransponrtResponse:(SHEventResultResponse *)response;

-(void)setVolumeResponse:(SHEventResultResponse *)response;

-(void)getVolumeResponse:(SHGetVolumResponse *)response;

-(void)getPositionInfoResponse:(SHPositionInfoResponse *)response;

-(void)OnSeekResult:(SHEventResultResponse *)response;

-(void)setMuteResponse:(SHEventResultResponse *)response;

//-(void)getTransportInfoResponse:(SHTransportInfoResponse *)response;

- (void)OnGetMediaInfoResult:(SHMediaInfoResponse*)response;

- (void)OnGetDeviceCapabilitiesResult:(SHDeviceCapabilitiesResponse*)response;

@end

@interface SHDMRControl : NSObject

@property (nonatomic, weak)id <SHDMRProtocolDelegate> delegate;
/***************************
 *
 * 媒体控制器相关(DMC)
 ***************************/

/**
 启动媒体控制器
 */
-(void)start;


/**
 重启媒体控制器
 */
-(void)restart;


/**
 停止
 */
-(void)stop;

-(BOOL)isRunning;
/*****************************
 *
 * 媒体服务器相关(DMS)
 *****************************/

- (void)intendStartItunesMusicServerWithServerName:(NSString *)theName;


/**
 获取附近媒体服务器

 */
-(NSArray *)getActiveServers;


/**
 根据uuid选择一个媒体服务器

 @param uuid uuid
 */
-(BOOL)chooseServerWithUUID:(NSString *)uuid;


/**
 获取当前的媒体服务器

 @return 返回
 */
-(id)getCurrentServer;


/***************************
 *
 *媒体渲染器(DMR)
 ***************************/


/**
    获取附近媒体渲染器(DMR)

 @return 返回数组
 */
-(NSArray <id> *)getActiveRenders;

/**
 使用uuid选择一个媒体渲染器

 @param uuid 传入uuid
 */
-(BOOL)chooseRenderWithUUID:(NSString *)uuid;


/**
 获取当前的媒体渲染器

 @return <#return value description#>
 */
-(id)getCurrentRender;

/**
 播放
 */
-(int)renderPlay;


/**
 暂停
 */
-(int)renderPause;


/**
 媒体渲染器停止
 */
-(int)renderStop;


-(int)canRendererSetNextURI;
-(int)renderNext;
-(int)renderPrevious;

/**
 设置当前播放URI

 @param uriStr URI
 @param didl DIDL
 */
-(int)renderSetAVTransportWithURI:(NSString *)uriStr metaData:(NSString *)didl;
-(int)setRendererNextAVTransportURI:(NSString *)uriStr;

//-(BOOL)renderSetVolume:(int)volume;
-(int)renderSetVolume:(int)volume withUserData:(id)userData;

-(int)renderGetVolume;

//设置静音
-(int)setRenderMute;

//取消静音
-(int)setRenderUnMute;

//设置进度
-(int)seekAudio:(NSInteger)seconds withUserData:(id)userData;

//获取进度信息
-(int)getRendererPositionInfo;

/**
 获取当前播放的媒体信息 只有  uri 可用 其他的数据是关于歌曲的基本信息，时长，模式等。
 */
-(int)getRendererMediaInfo;

//没有适合的数据。没鸟用
-(int)getRendererDeviceCapabilities;

@end
