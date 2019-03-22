//
//  FMusicTableViewCell.h
//  FDlna
//
//  Created by GaoAng on 2019/3/18.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMediaItem.h>

@interface FMusicTableViewCell : UITableViewCell

@property (nonatomic, strong) MPMediaItem *mItem;

@end

