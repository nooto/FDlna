//
//  SHDMRControlModel.m
//  PlatinumDemo
//
//  Created by GVS on 16/11/24.
//  Copyright © 2016年 GVS. All rights reserved.
//

#import "SHDMRControl.h"
#import "PltMicroMediaController.h"
#import <Platinum/Platinum.h>
#import "ItunesMusicDMSDelegate.h"

@implementation SHDMRControl
{
    PLT_UPnP * upnp;
    PLT_MicroMediaController * controller;
    
    PLT_MediaServerObject* itunesServer;
    ItunesMusicDMSDelegate *itunesDMSDelegate;
}
/***************************
 *
 * 媒体控制器相关(DMC)
 ***************************/

-(id)init
{
    if (self = [super init]) {
        upnp = new PLT_UPnP();
        PLT_CtrlPointReference ctrlPoint(new PLT_CtrlPoint());
        upnp->AddCtrlPoint(ctrlPoint);
        controller = new PLT_MicroMediaController(ctrlPoint,self);
    }
    return self;
}
-(void)dealloc
{
    delete upnp;
    delete controller;
}
/**
 启动媒体控制器
 */
-(void)start
{
    if (!upnp->IsRunning()) {
       NPT_Result result =  upnp->Start();
        NSLog(@"UPnP Service is starting! %zd",result);
    }else{
        NSLog(@"UPnP Service is starting!");
    }
}

/**
 重启媒体控制器
 */
-(void)restart
{
    if (upnp->IsRunning()) {
        upnp->Stop();
    }
    upnp->Start();
}


/**
 停止
 */
-(void)stop
{
    if (upnp->IsRunning() && upnp != NULL) {
        upnp->Stop();
    }
}
-(BOOL)isRunning
{
    if (upnp->IsRunning()) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 获取附近媒体服务器
/*****************************
 *
 * 媒体服务器相关(DMS)
 *****************************/
- (void)intendStartItunesMusicServerWithServerName:(NSString *)theName {
    itunesServer = [[PLT_MediaServerObject alloc] initServerSelfDelegateWithServerName:theName];
    itunesDMSDelegate = [[ItunesMusicDMSDelegate alloc] init];
//    [itunesDMSDelegate saveItuneMusicToServerDic];
    [itunesServer setDelegate:itunesDMSDelegate];
    NPT_Result result =  upnp->AddDevice([itunesServer getDevice]);
    NSLog(@"create  MusicServerServerName--%@  result:%zd", theName, result);
}

/**
 获取附近媒体服务器
 
 */
-(NSArray <id> *)getActiveServers
{
    NSMutableArray<id> * renderArray = [NSMutableArray array];
    const PLT_StringMap rendersNameTable = controller->getMediaServersNameTable();
    NPT_List<PLT_StringMapEntry *>::Iterator entry = rendersNameTable.GetEntries().GetFirstItem();
    while (entry) {
//        SHDeviceModel * renderModel = [[SHDeviceModel alloc] init];
//        renderModel.deviceName = [NSString stringWithUTF8String:(const char *)(*entry)->GetValue()];
//        renderModel.deviceUUID = [NSString stringWithUTF8String:(const char *)(*entry)->GetKey()];
//        renderModel.attribute =@{@"audio_uuid":renderModel.deviceUUID};
//        [renderArray addObject:renderModel];
        ++entry;
    }
    return renderArray;
}
#pragma mark -

/**
 根据uuid选择一个媒体服务器
 
 @param uuid 传入uuid
 */
-(BOOL)chooseServerWithUUID:(NSString *)uuid
{
    NPT_String newUUid = [uuid UTF8String];

    PLT_DeviceDataReference device = controller->getCurrentMediaServer();
    NPT_String oldUUID ;
    if (!device.IsNull()) {
        oldUUID = device->GetUUID();
    }
    
    if (newUUid != oldUUID) {
        return  controller -> chooseMeidaServer(newUUid);
    }
    
    return NO;
}

/**
 获取当前的媒体服务器
 
 @return 返回
 */
-(id)getCurrentServer
{
    PLT_DeviceDataReference device = controller->getCurrentMediaServer();
    if (!device.IsNull()) {
        NSString * name = [NSString stringWithUTF8String:device->GetFriendlyName()];
        NSString * uuid = [NSString stringWithUTF8String:device->GetUUID()];

        NSString * baseURL = [NSString stringWithUTF8String:device->GetURLBase().ToString()];
//        NSString * GetLocalIP = [NSString stringWithUTF8String:device->GetLocalIP().ToString()];
//        NSString * GetLocalIP1 = [NSString stringWithUTF8String:device->GetIconUrl()];
//        NSString * descriptionURL = [NSString stringWithUTF8String:device->GetDescriptionUrl()];


 
        /* 当前没有用到的属性屏蔽掉。 gaoang 2018年01月05日15:30:26
         NSString * manufacturer = [NSString stringWithUTF8String:device->m_Manufacturer];
         NSString * modelName = [NSString stringWithUTF8String:device->m_ModelName];
         NSString * modelNumber = [NSString stringWithUTF8String:device->m_ModelNumber];
         NSString * serialNumber = [NSString stringWithUTF8String:device->m_SerialNumber];
         NSString * descriptionURL = [NSString stringWithUTF8String:device->GetDescriptionUrl()];
         */
        //        SHRenderDeviceModel * renderDevice = [[SHRenderDeviceModel alloc] initWithName:name UUID:uuid Manufacturer:manufacturer ModelName:modelName ModelNumber:modelNumber SerialNumber:serialNumber DescriptionURL:descriptionURL];
        
//        SHDeviceModel *renderDevice = [[SHDeviceModel alloc] init];
//        renderDevice.deviceName = name;
//        renderDevice.deviceUUID = uuid;
//        if (baseURL.length > 0) {
//            renderDevice.attribute = @{kKeyDLNAMSUrl:baseURL};
//        }
//        return renderDevice;
        return nil;
    }else{
        NSLog(@"Render device is nil in %s",__FUNCTION__);
        return nil;
    }
    return nil;
}


/***************************
 *
 *媒体渲染器(DMR)
 ***************************/

/**
 获取附近媒体渲染器(DMR)
 
 @return 返回数组
 */
-(NSArray *)getActiveRenders
{
    NSMutableArray * renderArray = [NSMutableArray array];
    const PLT_StringMap rendersNameTable = controller->getMediaRenderersNameTable();
    NPT_List<PLT_StringMapEntry *>::Iterator entry = rendersNameTable.GetEntries().GetFirstItem();
    while (entry) {
//        SHDeviceModel * renderModel = [[SHDeviceModel alloc] init];
//        NSString *nameIp = [NSString stringWithUTF8String:(const char *)(*entry)->GetValue()];
//
//        NSString *deviceName = nameIp;
//        NSString *deviceIP;
//        NSRange range = [nameIp rangeOfString:@"#"];
//        if (range.location != NSNotFound) {
//            deviceName = [nameIp substringToIndex:range.location];
//            deviceIP = [nameIp substringFromIndex:(range.location + range.length)];
//        }
//
//        renderModel.deviceName = deviceName.length < 10 ? deviceName :[deviceName substringToIndex:10];
//        renderModel.deviceUUID = [NSString stringWithUTF8String:(const char *)(*entry)->GetKey()];
//        NSMutableDictionary *attributeDict = [[NSMutableDictionary alloc] initWithCapacity:4];
//        [attributeDict setValue:renderModel.deviceUUID forKey:kKeyAudioUuid];
//        [attributeDict setValue:renderModel.deviceUUID forKey:@"tv_mac"];
//        [attributeDict setValue:renderModel.deviceUUID forKey:@"bt_mac"];
//        [attributeDict setValue:deviceIP forKey:kKeyIP];
//        renderModel.attribute = attributeDict;
//        [renderArray addObject:renderModel];
        ++entry;
    }
    return renderArray;
}

/**
 使用uuid选择一个媒体渲染器
 
 @param uuid 传入uuid
 */
-(BOOL)chooseRenderWithUUID:(NSString *)uuid
{
    
    NPT_String newUUid = [uuid UTF8String];
    
    PLT_DeviceDataReference device = controller->getCurrentMediaRenderer();
    NPT_String oldUUID ;
    if (!device.IsNull()) {
        oldUUID = device->GetUUID();
    }
    
    if (newUUid != oldUUID) {
        return  controller -> chooseMediaRenderer([uuid UTF8String]);
    }
    
    return NO;
}


/**
 获取当前的媒体渲染器
 
 @return 返回
 */
-(id)getCurrentRender
{
    PLT_DeviceDataReference device = controller->getCurrentMediaRenderer();
    if (!device.IsNull()) {
        NSString * name = [NSString stringWithUTF8String:device->GetFriendlyName()];
        NSString * uuid = [NSString stringWithUTF8String:device->GetUUID()];
        
        /* 当前没有用到的属性屏蔽掉。 gaoang 2018年01月05日15:30:26
        NSString * manufacturer = [NSString stringWithUTF8String:device->m_Manufacturer];
        NSString * modelName = [NSString stringWithUTF8String:device->m_ModelName];
        NSString * modelNumber = [NSString stringWithUTF8String:device->m_ModelNumber];
        NSString * serialNumber = [NSString stringWithUTF8String:device->m_SerialNumber];
        NSString * descriptionURL = [NSString stringWithUTF8String:device->GetDescriptionUrl()];
        */
//        SHRenderDeviceModel * renderDevice = [[SHRenderDeviceModel alloc] initWithName:name UUID:uuid Manufacturer:manufacturer ModelName:modelName ModelNumber:modelNumber SerialNumber:serialNumber DescriptionURL:descriptionURL];
//        SHDeviceModel *renderDevice = [[SHDeviceModel alloc] init];
//        renderDevice.deviceName = name;
//        renderDevice.deviceUUID = uuid;
//        return renderDevice;
        return nil;
    }else{
        NSLog(@"Render device is nil in %s",__FUNCTION__);
        return nil;
    }    
}

/**
 播放
 */
-(int)renderPlay
{
    NPT_Result result = controller->setRendererPlay();
   return  (result);
}

/**
 暂停
 */
-(int)renderPause
{
    NPT_Result result = controller->setRendererPause();
    return  (result);
}


/**
 媒体渲染器停止
 */
-(int)renderStop
{
    NPT_Result result = controller->setRendererStop();
    return  (result);
}


-(int)canRendererSetNextURI{
    return  controller->canRendererSetNextURI();
}

/**
 下一首／下一集
 */
-(int)renderNext
{
    NPT_Result result = controller->setRendererNext();
    return  (result);

}


/**
 上一首／上一集
 */
-(int)renderPrevious
{
    NPT_Result result = controller->setRendererPrevious();
    return  (result);
}

/**
 设置当前播放URI
 
 @param uriStr URI
 @param didl DIDL
 */

-(int)renderSetAVTransportWithURI:(NSString *)uriStr metaData:(NSString *)didl
{
    if (didl == nil) {
        didl = @"";
    }
   NPT_Result result = controller->setRendererAVTransportURI([uriStr UTF8String], [didl UTF8String], (__bridge void *)@"2018年01月23日21:52:21");
    return  (result);
}

-(int)setRendererNextAVTransportURI:(NSString *)uriStr
{
    NPT_Result result = controller->setRendererNextAVTransportURI([uriStr UTF8String]);
    return  (result);
}

/**
 设置音量
 
 @param volume 传入音量
 */
-(int)renderSetVolume:(int)volume withUserData:(id)userData
{
//    if (volume <= 0) {
//        volume = 0;
//    }
//    if (volume >= 100) {
//        volume = 100;
//    }
    return (controller->setRendererVolume(volume, (__bridge void *)userData));
}

-(int)renderGetVolume
{
    return (controller->getRendererVolume());
}

-(int)setRenderMute{
    return controller->setRendererMute();
}

-(int)setRenderUnMute{
    return controller->setRendererUnMute();
}


-(int)seekAudio:(NSInteger)seconds withUserData:(id)userData{
    NSInteger hours = seconds / (60 *60);
    NSInteger lastSec = seconds % (60 *60);
    NSInteger minu = lastSec / 60;
    NSInteger sec = lastSec % 60;
    NSString *timeStr =[NSString stringWithFormat:@"%02zd:%02zd:%02zd", hours, minu, sec];
//    controller->sendSeekCommand([timeStr UTF8String]);
    return (controller->sendSeekCommand([timeStr UTF8String],(__bridge void *)userData));
}


-(int)getRendererPositionInfo{
    return (controller->getRendererPositionInfo());
}

-(int)getRendererMediaInfo
{
    return (controller->getRendererMediaInfo());
}

-(int)getRendererDeviceCapabilities{
    return  controller->getRendererDeviceCapabilities();
}

@end
