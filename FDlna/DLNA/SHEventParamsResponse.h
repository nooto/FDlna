//
//  SHEventParamsResponse.h
//  PlatinumDemo
//
//  Created by GVS on 16/11/24.
//  Copyright © 2016年 GVS. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 动作解析响应
 */
@interface SHEventParamsResponse : NSObject
@property (nonatomic, copy) NSString *deviceUUID;
@property (nonatomic, copy) NSString *serviceID;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *eventValue;
-(instancetype)initWithDeviceUUID:(NSString *)deviceUUID ServiceID:(NSString *)serviceID EventName:(NSString *)eventName EventValue:(NSString *)eventValue;
@end


/**
 动作结果响应
 */
@interface SHEventResultResponse : NSObject
@property (nonatomic, assign) NSInteger result;  //0：成功  -1：失败。
@property (nonatomic, copy) NSString *deviceUUID;
@property (nonatomic, strong) id    userData;
-(instancetype)initWithResult:(NSInteger)result DeviceUUID:(NSString *)deviceUUID UserData:(id)userData;
@end


/**
 当前动作响应
 */
@interface SHCurrentAVTransportActionResponse : SHEventResultResponse
@property (nonatomic, strong) NSArray<NSString *> *actions;
-(instancetype)initWithResult:(NSInteger)result DeviceUUID:(NSString *)deviceUUID Actions:(NSArray<NSString *> *)actions UserData:(id)userData;
@end

//获取音量的响应时间。
@interface SHGetVolumResponse : SHEventResultResponse
@property (nonatomic, copy)NSString * channel;
@property (nonatomic, assign)NSInteger volume;
-(instancetype)initWithResult:(NSInteger)result DeviceUUID:(NSString *)deviceUUID UserData:(id)userData Channel:(NSString *)channel Volume:(NSInteger)volume;
@end

/**
 当前投屏信息响应
 */
@interface SHTransportInfoResponse : SHEventResultResponse
@property (nonatomic, copy) NSString  *cur_transport_state;
@property (nonatomic, copy) NSString  *cur_transport_status;
@property (nonatomic, copy) NSString  *cur_speed;
@end


/**
 位置信息
 */
@interface SHPositionInfoResponse : SHEventResultResponse

@property (nonatomic, assign) NSUInteger    track;
@property (nonatomic, assign) NSTimeInterval    track_duration;
@property (nonatomic, copy)   NSString*    track_metadata;
@property (nonatomic, copy)   NSString*    track_uri;
@property (nonatomic, assign) NSTimeInterval    rel_time;
@property (nonatomic, assign) NSTimeInterval    abs_time;
@property (nonatomic, assign) NSInteger    rel_count;
@property (nonatomic, assign) NSInteger    abs_count;
@end


/**
 媒体信息
 */
@interface SHMediaInfoResponse : SHEventResultResponse

@property (nonatomic, assign) NSUInteger    num_tracks;
@property (nonatomic, assign) NSTimeInterval    media_duration;
@property (nonatomic, copy)   NSString*    cur_uri;
@property (nonatomic, copy)   NSString*    cur_metadata;
@property (nonatomic, copy)   NSString*    next_uri;
@property (nonatomic, copy)   NSString*    next_metadata;
@property (nonatomic, copy)   NSString*    play_medium;
@property (nonatomic, copy)   NSString*    rec_medium;
@property (nonatomic, copy)   NSString*    write_status;

@end

@interface SHDeviceCapabilitiesResponse : SHEventResultResponse


@property (nonatomic, strong)   NSArray*    capabilitiesArr;

@end



/*//
 {
 NPT_Reference<PLT_Service> service;
 
 {
//  AVTransport
service = new PLT_Service(
                          this,
                          "urn:schemas-upnp-org:service:AVTransport:1",
                          "urn:upnp-org:serviceId:AVTransport",
                          "AVTransport",
                          "urn:schemas-upnp-org:metadata-1-0/AVT/");
NPT_CHECK_FATAL(service->SetSCPDXML((const char*) RDR_AVTransportSCPD));
NPT_CHECK_FATAL(AddService(service.AsPointer()));

service->SetStateVariableRate("LastChange", NPT_TimeInterval(0.2f));
service->SetStateVariable("A_ARG_TYPE_InstanceID", "0");

// GetCurrentTransportActions
service->SetStateVariable("CurrentTransportActions", "Play,Pause,Stop,Seek,Next,Previous");

// GetDeviceCapabilities
service->SetStateVariable("PossiblePlaybackStorageMedia", "NONE,NETWORK,HDD,CD-DA,UNKNOWN");
service->SetStateVariable("PossibleRecordStorageMedia", "NOT_IMPLEMENTED");
service->SetStateVariable("PossibleRecordQualityModes", "NOT_IMPLEMENTED");

// GetMediaInfo
service->SetStateVariable("NumberOfTracks", "0");
service->SetStateVariable("CurrentMediaDuration", "00:00:00");
service->SetStateVariable("AVTransportURI", "");
service->SetStateVariable("AVTransportURIMetadata", "");;
service->SetStateVariable("NextAVTransportURI", "NOT_IMPLEMENTED");
service->SetStateVariable("NextAVTransportURIMetadata", "NOT_IMPLEMENTED");
service->SetStateVariable("PlaybackStorageMedium", "NONE");
service->SetStateVariable("RecordStorageMedium", "NOT_IMPLEMENTED");
service->SetStateVariable("RecordMediumWriteStatus", "NOT_IMPLEMENTED");

// GetPositionInfo
service->SetStateVariable("CurrentTrack", "0");
service->SetStateVariable("CurrentTrackDuration", "00:00:00");
service->SetStateVariable("CurrentTrackMetadata", "");
service->SetStateVariable("CurrentTrackURI", "");
service->SetStateVariable("RelativeTimePosition", "00:00:00");
service->SetStateVariable("AbsoluteTimePosition", "00:00:00");
service->SetStateVariable("RelativeCounterPosition", "2147483647"); // means NOT_IMPLEMENTED
service->SetStateVariable("AbsoluteCounterPosition", "2147483647"); // means NOT_IMPLEMENTED

// GetTransportInfo
service->SetStateVariable("TransportState", "NO_MEDIA_PRESENT");
service->SetStateVariable("TransportStatus", "OK");
service->SetStateVariable("TransportPlaySpeed", "1");

// GetTransportSettings
service->SetStateVariable("CurrentPlayMode", "NORMAL");
service->SetStateVariable("CurrentRecordQualityMode", "NOT_IMPLEMENTED");

service.Detach();
service = NULL;
}

{
//     ConnectionManager
    service = new PLT_Service(
                              this,
                              "urn:schemas-upnp-org:service:ConnectionManager:1",
                              "urn:upnp-org:serviceId:ConnectionManager",
                              "ConnectionManager");
    NPT_CHECK_FATAL(service->SetSCPDXML((const char*) RDR_ConnectionManagerSCPD));
    NPT_CHECK_FATAL(AddService(service.AsPointer()));
    
    service->SetStateVariable("CurrentConnectionIDs", "0");
    
    // put all supported mime types here instead
    service->SetStateVariable("SinkProtocolInfo", "http-get:*:video/x-ms-wmv:DLNA.ORG_PN=WMVMED_PRO,http-get:*:video/x-ms-asf:DLNA.ORG_PN=MPEG4_P2_ASF_SP_G726,http-get:*:video/x-ms-wmv:DLNA.ORG_PN=WMVMED_FULL,http-get:*:image/jpeg:DLNA.ORG_PN=JPEG_MED,http-get:*:video/x-ms-wmv:DLNA.ORG_PN=WMVMED_BASE,http-get:*:audio/L16;rate=44100;channels=1:DLNA.ORG_PN=LPCM,http-get:*:video/mpeg:DLNA.ORG_PN=MPEG_PS_PAL,http-get:*:video/mpeg:DLNA.ORG_PN=MPEG_PS_NTSC,http-get:*:video/x-ms-wmv:DLNA.ORG_PN=WMVHIGH_PRO,http-get:*:audio/L16;rate=44100;channels=2:DLNA.ORG_PN=LPCM,http-get:*:image/jpeg:DLNA.ORG_PN=JPEG_SM,http-get:*:video/x-ms-asf:DLNA.ORG_PN=VC1_ASF_AP_L1_WMA,http-get:*:audio/x-ms-wma:DLNA.ORG_PN=WMDRM_WMABASE,http-get:*:video/x-ms-wmv:DLNA.ORG_PN=WMVHIGH_FULL,http-get:*:audio/x-ms-wma:DLNA.ORG_PN=WMAFULL,http-get:*:audio/x-ms-wma:DLNA.ORG_PN=WMABASE,http-get:*:video/x-ms-wmv:DLNA.ORG_PN=WMVSPLL_BASE,http-get:*:video/mpeg:DLNA.ORG_PN=MPEG_PS_NTSC_XAC3,http-get:*:video/x-ms-wmv:DLNA.ORG_PN=WMDRM_WMVSPLL_BASE,http-get:*:video/x-ms-wmv:DLNA.ORG_PN=WMVSPML_BASE,http-get:*:video/x-ms-asf:DLNA.ORG_PN=MPEG4_P2_ASF_ASP_L5_SO_G726,http-get:*:image/jpeg:DLNA.ORG_PN=JPEG_LRG,http-get:*:audio/mpeg:DLNA.ORG_PN=MP3,http-get:*:video/mpeg:DLNA.ORG_PN=MPEG_PS_PAL_XAC3,http-get:*:audio/x-ms-wma:DLNA.ORG_PN=WMAPRO,http-get:*:video/mpeg:DLNA.ORG_PN=MPEG1,http-get:*:image/jpeg:DLNA.ORG_PN=JPEG_TN,http-get:*:video/x-ms-asf:DLNA.ORG_PN=MPEG4_P2_ASF_ASP_L4_SO_G726,http-get:*:audio/L16;rate=48000;channels=2:DLNA.ORG_PN=LPCM,http-get:*:audio/mpeg:DLNA.ORG_PN=MP3X,http-get:*:video/x-ms-wmv:DLNA.ORG_PN=WMVSPML_MP3,http-get:*:video/x-ms-wmv:*");
    service->SetStateVariable("SourceProtocolInfo", "");
    
    service.Detach();
    service = NULL;
}

{
//     RenderingControl
    service = new PLT_Service(
                              this,
                              "urn:schemas-upnp-org:service:RenderingControl:1",
                              "urn:upnp-org:serviceId:RenderingControl",
                              "RenderingControl",
                              "urn:schemas-upnp-org:metadata-1-0/RCS/");
    NPT_CHECK_FATAL(service->SetSCPDXML((const char*) RDR_RenderingControlSCPD));
    NPT_CHECK_FATAL(AddService(service.AsPointer()));
    
    service->SetStateVariableRate("LastChange", NPT_TimeInterval(0.2f));
    
    service->SetStateVariable("Mute", "0");
    service->SetStateVariableExtraAttribute("Mute", "Channel", "Master");
    service->SetStateVariable("Volume", "100");
    service->SetStateVariableExtraAttribute("Volume", "Channel", "Master");
    service->SetStateVariable("VolumeDB", "0");
    service->SetStateVariableExtraAttribute("VolumeDB", "Channel", "Master");
    
    service->SetStateVariable("PresetNameList", "FactoryDefaults");
    
    service.Detach();
    service = NULL;
}

return NPT_SUCCESS;
}
 
 //*/

