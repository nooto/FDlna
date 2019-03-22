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
- (void)fetchLocalMusicAssetsWithCompletion:(void(^)(NSArray *loacalItems))completion {
    
    if (self.mSourctDatas.count) {
        if (completion) {
            completion(self.mSourctDatas);
        }
    } else {
        if (@available(iOS 9.3, *)) {
            MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
            if (status == MPMediaLibraryAuthorizationStatusNotDetermined) {
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
        } else {
            [self queryMediaDatasWithCompletion:completion];
        }
    }
}

- (void)queryMediaDatasWithCompletion:(void(^)(NSArray *loacalItems))completion {
    
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
            completion(result.copy);
        }
    });
}

- (void)restrictedAccessToMediaLibraryWithCompletion:(void(^)(NSArray *loacalItems))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (completion) {
            completion(nil);
        }
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:[NSString stringWithFormat:@"请允许%@访问您的媒体库", [infoDictionary objectForKey:@"CFBundleDisplayName"]]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"q允许" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [RootViewController presentViewController:alert animated:YES completion:nil];
    });
}


@end
