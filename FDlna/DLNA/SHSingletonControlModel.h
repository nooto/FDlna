//
//  SHSearchDevice.h
//  PlatinumDemo
//
//  Created by GVS on 16/11/24.
//  Copyright © 2016年 GVS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHDMRControl.h"

/**
 用来启动服务的单例类
 */
@interface SHSingletonControlModel : NSObject
@property (nonatomic, strong)SHDMRControl * DMRControl;
+(SHSingletonControlModel *)sharedInstance;
@end
