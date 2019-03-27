//
//  FMainEmptyView.h
//  FDlna
//
//  Created by GaoAng on 2019/3/26.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMainEmptyView : UIView
@property (nonatomic, strong, readonly)  UIImageView *iconImageView;
@property (nonatomic, strong, readonly)  UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *detailLabel;
@property (nonatomic, copy) void (^clickDefaultViewCompletion)(void);//点击屏幕回调

@end
