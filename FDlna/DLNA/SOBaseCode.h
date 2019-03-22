//
//  SOBaseCode.h
//  FDlna
//
//  Created by GaoAng on 2019/3/22.
//  Copyright © 2019年 Self.work. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 * key值定义
 */
static NSString * const kKeyRouterID = @"router_id";
static NSString * const kKeyFamilyID = @"family_id";
static NSString * const kKeyUserID = @"user_id";
static NSString * const kKeyUnionID = @"union_id";
static NSString * const kKeyRoomID = @"room_id";
static NSString * const kKeyDeviceID = @"device_id";
static NSString * const kKeyClientID = @"client_id";
static NSString * const kKeyProto = @"proto";
static NSString * const kKeyIsDlna = @"is_dlna";

static NSString * const kKeyPwd = @"pwd";
static NSString * const kKeyPwdOld = @"pwd_old";
static NSString * const kKeyPwdNew = @"pwd_new";

static NSString * const kKeyUuid = @"uuid";
static NSString * const kKeyRouterUuid = @"router_uuid";
static NSString * const kKeyRouterPwd = @"router_pwd";
static NSString * const kKeyRouter = @"router";


static NSString * const kKeyCallID = @"callid";
static NSString * const kKeyRouterRequest = @"router_request";
static NSString * const kKeyResolution = @"resolution";
static NSString * const kKeySdp = @"sdp";
static NSString * const kKeyM = @"m";

static NSString * const kKeySecret = @"secret";
static NSString * const kKeyPhone = @"phone";

static NSString * const kKeyType = @"type";
static NSString * const kKeyToken = @"token";
static NSString * const kKeyIsAccessToken = @"is_ac_token";
static NSString * const kKeyAccountToken = @"account_token";
static NSString * const kKeyAuthToken = @"auth_token";
static NSString * const kKeyOsType = @"os_type";
static NSString * const kKeyVersion = @"version";
static NSString * const kKeyOldVersion = @"old_version";
static NSString * const kKeyAppVersion = @"app_version";
static NSString * const kKeyOsVersion = @"os_version";
static NSString * const kKeyHardwareVersion = @"hardware_version";
static NSString * const kKeyPhoneName = @"phone_name";
static NSString * const kKeySSO = @"sso";

static NSString * const kKeyAudioUuid = @"audio_uuid";

static NSString * const kKeyUserName = @"user_name";
static NSString * const kKeyName = @"name";
static NSString * const kKeyNick = @"nick";
static NSString * const kKeyGender = @"gender";
static NSString * const kKeyAvatar = @"avatar";
static NSString * const kKeyBirthday = @"birthday";

static NSString * const kKeyRoomName = @"room_name";
static NSString * const kKeyRoomIcon = @"room_icon";
static NSString * const kKeyIsDefault = @"is_default";
static NSString * const kKeyOrder = @"order";

static NSString * const kKeyList = @"list";
static NSString * const kKeyMsgList = @"msg_list";
static NSString * const kKeyUpgrade = @"upgrade";
static NSString * const kKeyDescription = @"description";
static NSString * const kKeyDownload_url = @"download_url";
static NSString * const kKeyForce = @"force";
static NSString * const kRouterVersion = @"router_version";
static NSString * const kKeyNotice = @"notice";
static NSString * const kKeyUpgrade_sta = @"upgrade_sta";



static NSString * const kKeyDLNAMSUrl = @"dlna_ms_url";

static NSString * const kKeyFamilyName = @"family_name";
static NSString * const kKeyFamilyAvatar = @"family_avatar";
static NSString * const kKeyAppUUID = @"app_uuid";

static NSString * const kKeyTargetUserID = @"target_user_id";

static NSString * const kKeyApplyID = @"apply_id";

static NSString * const kKeyDeviceUUID = @"device_uuid";
static NSString * const kKeyProductID = @"product_id";
static NSString * const kKeyAppId = @"app_id";
static NSString * const kKeyBussinessUserID = @"bussiness_user_id";
static NSString * const kKeyDeviceCategoryID = @"device_category_id";
static NSString * const kKeyCategoryID = @"category_id";
static NSString * const kKeyCategorySub = @"category_sub";
static NSString * const kKeyDeviceName = @"device_name";
static NSString * const kKeyDeviceAttrExt = @"device_attr_ext";

static NSString * const kKeyPage = @"page";
static NSString * const kKeySize = @"size";
static NSString * const kKeyBegin = @"begin";

static NSString * const kKeyStatusID = @"status_id";

static NSString * const kKeyReportType = @"report_type";
static NSString * const kKeyReportMsg = @"report_msg";
static NSString * const kKeyCreatedAt = @"created_at";
static NSString * const kKeyStatusModifiedAt = @"status_modified_at";
static NSString * const kKeyUpdatedAt = @"updated_at";

static NSString * const kKeyKey = @"key";

static NSString * const kKeyIP = @"ip";
static NSString * const kKeyPort = @"port";

static NSString * const kKeyUrl= @"url";

//TV
static NSString * const kKeyModel = @"model";
static NSString * const kKeyManufactureName = @"manufacture_name";
static NSString * const kKeyTvMac = @"tv_mac";
static NSString * const kKeyBtMac = @"bt_mac";
static NSString * const kKeySwitch = @"switch";
static NSString * const KKeyToggle = @"toggle";

//router
static NSString * const kKeyPassword = @"password";
static NSString * const kKeyClearUserData = @"clearUserData";
static NSString * const kKeyConfig = @"config";
static NSString * const kKeyPrimaryDns = @"primary_dns";
static NSString * const kKeySecondDns = @"second_dns";
static NSString * const kKeyUser = @"user";

static NSString * const kKeyMask = @"mask";
static NSString * const kKeyGateway = @"gateway";

static NSString * const kKeySSID = @"SSID";
static NSString * const kKeyEnable = @"enable";
static NSString * const kKeyHide = @"hide";
static NSString * const kKeySignalStrength = @"txpower";

static NSString * const kKeyStatus = @"status";

static NSString * const kKeyClearData = @"clear_data";

static NSString * const kKeyImage = @"image";

static NSString * const kEventStatues = @"EventStatues";
static NSString * const kEventStatuesData = @"eventStatuesData";
static NSString *const kKeyShortcutID = @"shortcut_id";
static NSString *const kKeyAppVisible = @"app_visible";
static NSString *const kKeyLevel = @"level";


static NSString *const kKeySpeed = @"speed";

static NSString *const kKeyTemperature = @"temperature";

static NSString *const kKeyLow = @"low";

static NSString *const kKeyHigh = @"high";
static NSString *const kKeyAuto = @"auto";

static NSString *const kKeySwitchStatus = @"switchStatus";
static NSString *const kKeySwitch_Status = @"switch_status";
static NSString *const kKeyChan = @"chan";
static NSString *const kKeyConfigList = @"config_list";
static NSString *const kKeyChanNum = @"chan_num";
static NSString *const kKeyChanName = @"chan_name";
static NSString *const kKeyChanIndex = @"chan_index";
static NSString *const kKeyBindUuid = @"bind_uuid";
static NSString *const kKeyConnectivity = @"connectivity";

static NSString *const kKeyOpenPercentage = @"open_percentage";

static NSString *const kKeyOn = @"on";
static NSString *const kKeyOff = @"off";

static NSString *const kKeyPlatform = @"platform";
static NSString *const kKeyBindTime = @"bind_time";

static NSString *const kKeyMidList = @"mid_list";

static NSString *const kKeyBeginHour = @"begin_hour";
static NSString *const kKeyBeginMin = @"begin_min";
static NSString *const kKeyEndHour = @"end_hour";
static NSString *const kKeyEndMin = @"end_min";

static NSString *const kKeyBeginDate = @"begin_date";
static NSString *const kKeyEndDate = @"end_date";

static NSString *const kKeyCollectMediaID = @"collect_media_id";//收藏元素id
static NSString *const kKeyCollectID = @"collect_id";//收藏id(后台生成并返回)
static NSString *const kKeyCollectInfoList = @"collect_info_list";//收藏信息列表

static NSString *const kKeyIOS_version = @"ios_version";

static NSString *const kAppName = @"smart_community";//融合版app名称
