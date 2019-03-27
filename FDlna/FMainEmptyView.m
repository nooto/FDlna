//
//  FMainEmptyView.m
//  FDlna
//
//  Created by GaoAng on 2019/3/26.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import "FMainEmptyView.h"
#import <YYKit.h>
#import <StepOHelper.h>
@interface FMainEmptyView (){
    
}

@property (nonatomic,strong)  UIImageView *iconImageView;
@property (nonatomic,strong)  UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@end


@implementation FMainEmptyView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    self.backgroundColor = [UIColor whiteColor];

    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,180, 180)];
    self.iconImageView.center = self.center;
    self.iconImageView.centerY = self.centerY -  100;
    self.iconImageView.image = [UIImage imageNamed:@"img_noschedule"];
    [self addSubview:self.iconImageView];

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 18)];
    self.titleLabel.top = self.iconImageView.bottom + 18;
    self.titleLabel.centerX = self.width/2.0f;
    self.titleLabel.font = kPingfangMediumFont(16.0f);
    self.titleLabel.textColor = [UIColor colorWithHexString:@"A4A9AF"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.titleLabel.text = kNoDataString;
    [self addSubview:self.titleLabel];

    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.titleLabel.bottom + 15, self.width - 2*20, 0)];
    self.detailLabel.centerX = self.width/2.0f;
    self.detailLabel.font = kPingfangRegularFont(16.0f);
    self.detailLabel.textColor = [UIColor colorWithHexString:@"A4A9AF"];;
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.numberOfLines = 0;
    [self addSubview:self.detailLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDefaultView:)];
    [self addGestureRecognizer:tap];
}


#pragma mark - actionMethod
- (void)clickDefaultView:(UITapGestureRecognizer *)tap{
    if (self.clickDefaultViewCompletion) {
        self.clickDefaultViewCompletion();
    }
}

@end
