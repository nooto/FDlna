//
//  FDiscoveryViewCell.h
//  FDlna
//
//  Created by GaoAng on 2019/3/22.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDiscoveryViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *mDeviceDict;

- (void)setMDeviceDict:(NSDictionary *)mDeviceDict isCurrentDevice:(BOOL)isCurrentDevice;
@end
