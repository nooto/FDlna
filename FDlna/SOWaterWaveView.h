//
//  SOWaterWaveView.h
//  FDlna
//
//  Created by GaoAng on 2019/3/27.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SOWaterWaveView : UIView
@property (nonatomic, copy) void (^finishAnimate)(BOOL isForce);
- (void)startAnimated;
- (void)stopAnimated;

@end
