//
//  FLocalMusicServices.h
//  FDlna
//
//  Created by GaoAng on 2019/3/18.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FLocalMusicServices : NSObject

+ (instancetype)sharedInstance;

- (void)fetchLocalMusicAssetsWithCompletion:(void(^)(NSArray *loacalItems))completion;

@end
