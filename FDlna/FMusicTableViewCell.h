//
//  FMusicTableViewCell.h
//  FDlna
//
//  Created by GaoAng on 2019/3/18.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMediaItem.h>
typedef NS_ENUM(NSInteger, SOSongStatus) {
    SOSongStatu_Default = 1, //默认状态
    SOSongStatu_Playing = 2, //正在播放
    SOSongStatu_Pause = 3,   //暂停状态
};

@interface FMusicTableViewCell : UITableViewCell

@property (nonatomic, strong) MPMediaItem *mItem;

- (void)loarCellWithMediaitem:(MPMediaItem*)item songStatus:(SOSongStatus)status;
@end

