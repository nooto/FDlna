//
//  SHSearchDevice.m
//  PlatinumDemo
//
//  Created by GVS on 16/11/24.
//  Copyright © 2016年 GVS. All rights reserved.
//

#import "SHSingletonControlModel.h"

@implementation SHSingletonControlModel
+(SHSingletonControlModel *)sharedInstance
{
    static SHSingletonControlModel * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SHSingletonControlModel alloc] init];
        
    });
    return instance;
}
-(instancetype)init
{
    if (self = [super init]) {
        _DMRControl = [[SHDMRControl alloc] init];
        [_DMRControl start];
    }
    return self;
}

@end
