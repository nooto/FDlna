//
//  SONavigationView.m
//  FDlna
//
//  Created by GaoAng on 2019/3/15.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import "SONavigationView.h"

@interface SONavigationView ()
@end

@implementation SONavigationView

-(id)initWithdelegate:(id)delegate{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_W, NAVBAR_H)]) {
        self.m_delegate = delegate;
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    self.backgroundColor = [UIColor grayColor];//Color_BackGround;
    self.userInteractionEnabled = YES;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame) - 20)];
    [self addSubview:titleLabel];
    titleLabel.center = CGPointMake(SCREEN_W/2, CGRectGetHeight(self.bounds)/2 + 10);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:19];
    titleLabel.textColor = [UIColor redColor];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.mTextLabel = titleLabel;
    
    SONavButton* leftButton =  [[SONavButton alloc] initWithFrame:CGRectMake(20, 20, NAVBAR_H, NAVBAR_H-20)];
    [leftButton setImage:[UIImage imageNamed:@"global_arrow_previous"] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButonAction:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.titleLabel.font = _mTextLabel.font;
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self addSubview:leftButton];
    self.mLeftButton = leftButton;
    
    SONavButton* rightButton =  [[SONavButton alloc] initWithFrame:CGRectMake(SCREEN_W - 20 - NAVBAR_H,20, NAVBAR_H, NAVBAR_H - 20)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    rightButton.titleLabel.font = _mTextLabel.font;
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self addSubview:rightButton];
    self.mRightButton = rightButton;

    UIView *mline = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 1.0f, SCREEN_W, 1.0f)];
    mline.backgroundColor = [UIColor lightGrayColor];
    mline.hidden = YES;
    [self addSubview:mline];
    self.mLineView = mline;
}

-(void)setBackgroundColorClear{
    self.backgroundColor = [UIColor clearColor];
    self.layer.shadowPath = nil;
    [self.mTextLabel setTextColor:[UIColor whiteColor]];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    [self.mTextLabel setText:title];
    self.mTextLabel.center = CGPointMake(SCREEN_W/2, CGRectGetHeight(self.bounds)/2 + 10);
}
-(void)leftButonAction:(SONavButton*)sender{
    if (_m_delegate && [_m_delegate respondsToSelector:@selector(backBtnPressed:)]) {
        [_m_delegate backBtnPressed:sender];
    }
}

@end
