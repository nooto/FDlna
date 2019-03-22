//
//  AppDelegate.h
//  FDlna
//
//  Created by GaoAng on 2019/3/15.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMainViewController.h"
#define APPDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))
#define RootViewController ((AppDelegate *)([UIApplication sharedApplication].delegate)).rootVC

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) FBaseViewController *rootVC;
@end

