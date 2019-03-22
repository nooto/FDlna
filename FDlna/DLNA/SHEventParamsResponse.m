//
//  SHEventParamsResponse.m
//  PlatinumDemo
//
//  Created by GVS on 16/11/24.
//  Copyright © 2016年 GVS. All rights reserved.
//

#import "SHEventParamsResponse.h"

@implementation SHEventParamsResponse
-(instancetype)initWithDeviceUUID:(NSString *)deviceUUID ServiceID:(NSString *)serviceID EventName:(NSString *)eventName EventValue:(NSString *)eventValue
{
    if (self = [super init]) {
        self.deviceUUID = deviceUUID;
        self.serviceID = serviceID;
        self.eventName = eventName;
        self.eventValue = eventValue;
    }
    return self;
}
@end

@implementation SHEventResultResponse

-(instancetype)initWithResult:(NSInteger)result DeviceUUID:(NSString *)deviceUUID UserData:(id)userData
{
    if (self = [super init]) {
        self.result = result;
        self.deviceUUID = deviceUUID;
        self.userData = userData;
    }
    return self;
}
@end

@implementation SHCurrentAVTransportActionResponse

-(instancetype)initWithResult:(NSInteger)result DeviceUUID:(NSString *)deviceUUID Actions:(NSArray<NSString *> *)actions UserData:(id)userData
{
    if (self = [super initWithResult:result DeviceUUID:deviceUUID UserData:userData]) {
        self.actions = actions;
    }
    return self;
}

@end

@implementation SHGetVolumResponse 

-(instancetype)initWithResult:(NSInteger)result DeviceUUID:(NSString *)deviceUUID UserData:(id)userData Channel:(NSString *)channel Volume:(NSInteger)volume
{
    if (self = [super initWithResult:result DeviceUUID:deviceUUID UserData:userData]) {
        self.channel = channel;
        self.volume = volume;
    }
    return self;
}

@end

@implementation SHTransportInfoResponse

-(NSString *)description
{
    return [NSString stringWithFormat:@"cur_transport_status:%@-cur_transport_state:%@-cur_speed:%@",self.cur_transport_status,self.cur_transport_state,self.cur_speed];
}

@end



@implementation SHPositionInfoResponse
-(NSString *)description
{
    return [NSString stringWithFormat:@"track:%lu \
            -track_duration:%f\
            -track_metadata:%@\
            -track_uri:%@\
            -rel_time:%f\
            -abs_time:%f\
            -rel_count:%ld\
            -abs_count:%ld",
            (unsigned long)self.track,self.track_duration,self.track_metadata,
            self.track_uri,self.rel_time,self.abs_time,
            (long)self.rel_count,(long)self.abs_count
            ];
}
@end

@implementation SHMediaInfoResponse
-(NSString *)description
{
    return [NSString stringWithFormat:@"num_tracks:%lu \
            -media_duration:%f\
            -cur_uri:%@\
            -cur_metadata:%@\
            -next_uri:%@\
            -next_metadata:%@\
            -play_medium:%@\
            -rec_medium:%@\
            -write_status:%@",
            (unsigned long)self.num_tracks,
            self.media_duration,
            self.cur_uri,
            self.cur_metadata,
            self.next_uri,
            self.next_metadata,
            self.play_medium,
            self.rec_medium,
            self.write_status
            ];
}
@end


@implementation SHDeviceCapabilitiesResponse
@end





