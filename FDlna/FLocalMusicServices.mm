//
//  FLocalMusicServices.m
//  FDlna
//
//  Created by GaoAng on 2019/3/18.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import "FLocalMusicServices.h"
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MPMediaLibrary.h>
#import <MediaPlayer/MPMediaQuery.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <Platinum/Platinum.h>
#import <StepOHelper.h>
@interface FLocalMusicServices ()
@property (nonatomic, strong) NSArray *mSourctDatas;
@end

@implementation FLocalMusicServices

+ (instancetype)sharedInstance {
    static FLocalMusicServices *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[FLocalMusicServices alloc]init];
    });
    return shared;
}

#pragma mark - 本地音乐
- (void)fetchLocalMusicAssetsWithCompletion:(void(^)(BOOL isAccess, NSArray *loacalItems))completion {
    if (self.mSourctDatas.count) {
        if (completion) {
            completion(YES, self.mSourctDatas);
        }
        return;
    }
    
    if (@available(iOS 9.3, *)) {
            MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
            if (status == MPMediaLibraryAuthorizationStatusNotDetermined || status == MPMediaLibraryAuthorizationStatusDenied) {
                [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                    if (status == MPMediaLibraryAuthorizationStatusAuthorized) {
                        [self queryMediaDatasWithCompletion:completion];
                    } else {
                        [self restrictedAccessToMediaLibraryWithCompletion:completion];
                    }
                }];
            } else if (status == MPMediaLibraryAuthorizationStatusAuthorized) {
                [self queryMediaDatasWithCompletion:completion];
            } else {
                [self restrictedAccessToMediaLibraryWithCompletion:completion];
            }
        }
    else{
        //查询数据。
        [self queryMediaDatasWithCompletion:completion];
    }
    
}


- (void)queryMediaDatasWithCompletion:(void(^)(BOOL isAccess, NSArray *loacalItems))completion {
    
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    
    // 2.创建读取条件(类似于对数据做一个筛选)  Value：作用等同于MPMediaType枚举值
    MPMediaPropertyPredicate *albumNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic ] forProperty: MPMediaItemPropertyMediaType];
    //3.给队列添加读取条件
    [query addFilterPredicate:albumNamePredicate];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *result = @[].mutableCopy;
        NSArray *queryItems = query.items;
        for (MPMediaItem *temp in queryItems) {
            [result addObject:temp];
        }
        self.mSourctDatas = result.copy;
        if (completion) {
            completion(YES,  result.copy);
        }
    });
}

- (void)restrictedAccessToMediaLibraryWithCompletion:(void(^)(BOOL isAccess, NSArray *loacalItems))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

        SOCustomAlertView *alertView =  [[SOCustomAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"请允许%@访问您的媒体库", [infoDictionary objectForKey:@"CFBundleDisplayName"]] leftButton:@"允许" rightButton:@"暂不允许"];
//        [alertView.mLeftButton setBackgroundColor:UIColorFromHexString(@"#0159D7")];
        [SOAlertManagerShareInstance showAlertView:alertView];
        [alertView setDidSelcectButtonAtIndexWithTitle:^(NSInteger selectIndex, NSString *buttonText) {
            if (selectIndex == 0) {
                [SOTools openApplicationOpenSetting];
            }
            else{
                if (completion) {
                    completion(NO, nil);
                }
            }
        }];
    });
}


@end
