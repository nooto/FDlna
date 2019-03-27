//
//  SOWaterWaveView.m
//  FDlna
//
//  Created by GaoAng on 2019/3/27.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import "SOWaterWaveView.h"
#import <StepOHelper.h>
@interface SOWaterWaveView(){
    float _horizontal;
    float _horizontal2;
    float waterHeight;
    CGFloat WaterMaxHeight;
}

@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UIView *dianliangView;
@property (nonatomic, strong) UIView *dianliangView2;
/** 圆CAShapeLayer */
@property(nonatomic,strong)CAShapeLayer *ovalShapeLayer;
@property (nonatomic, strong) NSTimer *waterTimer;
@property (nonatomic, strong) UILabel *dianliangLbel;

@property (nonatomic, assign) CGFloat  waveWidth;
//@property (nonatomic, assign) CGFloat  WaterMaxHeight;
@property (nonatomic, assign) NSInteger count;
@end

@implementation SOWaterWaveView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.waveWidth = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame));
        WaterMaxHeight= self.waveWidth/2;
        self.count = 0;
        [self setupView];
    }
    return self;
}

- (void)dealloc{
    [_waterTimer invalidate];
    _waterTimer = nil;
    
}
- (void)setupView{
    [self addSubview:self.circleView];
    //  第一层浅白色的虚线圆
    CAShapeLayer *ovalLayer = [CAShapeLayer layer];
    ovalLayer.strokeColor = [UIColor colorWithRed:0.64 green:0.71 blue:0.87 alpha:1.00].CGColor;
    ovalLayer.fillColor = [UIColor clearColor].CGColor;
    ovalLayer.lineWidth = 20;
    ovalLayer.lineDashPattern  = @[@3, @6];
    ovalLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.circleView.bounds].CGPath;
    [self.circleView.layer addSublayer:ovalLayer];
    
    // 第二层黄色的虚线圆 电量多少的
    self.ovalShapeLayer = [CAShapeLayer layer];
    self.ovalShapeLayer.strokeColor = [UIColor yellowColor].CGColor;
    self.ovalShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.ovalShapeLayer.lineWidth = ovalLayer.lineWidth;
    self.ovalShapeLayer.lineDashPattern  = ovalLayer.lineDashPattern;
    self.ovalShapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.circleView.bounds].CGPath;
    self.ovalShapeLayer.strokeEnd = 0.5f;
    [self.circleView.layer addSublayer:self.ovalShapeLayer];

    // 白色实线的小圆圈
    CAShapeLayer *ocircleLayer = [CAShapeLayer layer];
    ocircleLayer.strokeColor = [UIColor colorWithRed:0.64 green:0.71 blue:0.87 alpha:1.00].CGColor;
    ocircleLayer.fillColor = [UIColor clearColor].CGColor;
    ocircleLayer.lineWidth = 1;
    CGRect ocRect = CGRectInset(self.circleView.bounds, ovalLayer.lineWidth + 1, ovalLayer.lineWidth + 1);
    ocircleLayer.path = [UIBezierPath bezierPathWithOvalInRect:ocRect].CGPath;
    [self.circleView.layer addSublayer:ocircleLayer];
    
//    /// 第一层水波纹view ===========================
    self.dianliangView = [[UIView alloc] initWithFrame:ocRect];
    self.dianliangView.center = self.circleView.center;
    [self addSubview:self.dianliangView];
    self.dianliangView.layer.cornerRadius = CGRectGetWidth(self.dianliangView.frame)/2;
    self.dianliangView.layer.masksToBounds = YES;
    self.dianliangView.backgroundColor = [UIColor colorWithRed:0.34 green:0.40 blue:0.71 alpha:0.80];

    /// 第二层水波纹 view =======================
    self.dianliangView2 = [[UIView alloc] initWithFrame:self.dianliangView.frame];
    [self addSubview:self.dianliangView2];
    self.dianliangView2.center = self.circleView.center;
    self.dianliangView2.layer.cornerRadius = CGRectGetWidth(self.dianliangView2.frame)/2;
    self.dianliangView2.layer.masksToBounds = YES;
    self.dianliangView2.backgroundColor = [UIColor colorWithRed:0.32 green:0.52 blue:0.82 alpha:0.60];
    
    waterHeight = CGRectGetHeight(self.dianliangView2.frame);
    WaterMaxHeight = waterHeight;
    
    self.dianliangLbel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.dianliangView2.frame), 30)];
    [self addSubview:self.dianliangLbel];
    self.dianliangLbel.center = self.circleView.center;
    self.dianliangLbel.font = [UIFont systemFontOfSize:25];
    self.dianliangLbel.textAlignment = NSTextAlignmentCenter;
    self.dianliangLbel.textColor = [UIColor whiteColor];
    
    [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(waterAction) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(waterAction2) userInfo:nil repeats:YES];
}


- (void)waterAction{
    CGMutablePathRef wavePath = CGPathCreateMutable();
    CGPathMoveToPoint(wavePath, nil, 0,waterHeight);
    float y = 0;
    _horizontal += 0.15;
    for (float x = 0; x <= self.dianliangView.frame.size.width; x++) {
        //峰高* sin(x * M_PI / self.frame.size.width * 峰的数量 + 移动速度)
        y = 7* sin(x * M_PI / self.dianliangView.frame.size.width * 2 - _horizontal) ;
        CGPathAddLineToPoint(wavePath, nil, x, y+waterHeight);
    }
    CGPathAddLineToPoint(wavePath, nil, self.dianliangView.frame.size.width , waterHeight);
    CGPathAddLineToPoint(wavePath, nil, self.dianliangView.frame.size.width, WaterMaxHeight);
    CGPathAddLineToPoint(wavePath, nil, 0, WaterMaxHeight);
    [self.dianliangView setShape:wavePath];
}

- (void)waterAction2{
    CGMutablePathRef wavePath2 = CGPathCreateMutable();
    CGPathMoveToPoint(wavePath2, nil, 0,-waterHeight);
    float y2 = 0;
    _horizontal2 += 0.1;
    for (float x2 = 0; x2 <= self.dianliangView2.frame.size.width; x2++) {
        //峰高* sin(x * M_PI / self.frame.size.width * 峰的数量 + 移动速度)
        y2 = -5* cos(x2 * M_PI / self.dianliangView2.frame.size.width * 2 + _horizontal2) ;
        CGPathAddLineToPoint(wavePath2, nil, x2, y2+waterHeight);
    }
    CGPathAddLineToPoint(wavePath2, nil, self.dianliangView2.frame.size.width , waterHeight);
    CGPathAddLineToPoint(wavePath2, nil, self.dianliangView2.frame.size.width, WaterMaxHeight);
    CGPathAddLineToPoint(wavePath2, nil, 0, WaterMaxHeight);
    [self.dianliangView2 setShape:wavePath2];
}


- (void)sliderAction:(UISlider *)slider{
    self.ovalShapeLayer.strokeEnd = slider.value;
    if (slider.value >= 0 || slider.value <= 1){
        waterHeight = (1 - slider.value)*(CGRectGetHeight(self.dianliangView2.frame));
        self.dianliangLbel.text = [NSString stringWithFormat:@"%.0f%@",slider.value*100,@"%"];
        self.dianliangLbel.text = [NSString stringWithFormat:@"%.0f%@",waterHeight,@"%"];
    }else{
        NSLog(@"progress value is error");
    }
    
}

- (void)startAnimated{
    [self.waterTimer fire];
}

- (void)stopAnimated{
    [self didStopAnimated];
    if (self.finishAnimate) {
        self.finishAnimate(YES);
    }
}

- (void)didStopAnimated{
    if (_waterTimer) {
        self.count = 0;
        [_waterTimer  invalidate];
        _waterTimer = nil;
    }
}



- (void)waterChangeAction:(NSTimer*)timer{
    if (self.count >= 60) {
        [self didStopAnimated];
        if (self.finishAnimate) {
            self.finishAnimate(NO);
        }
    }
    else{
        CGFloat tFloat = (CGFloat)self.count / 60.f;
        self.ovalShapeLayer.strokeEnd = (CGFloat)self.count / 60.f;;
        waterHeight = tFloat*(CGRectGetHeight(self.dianliangView2.frame));
        self.dianliangLbel.text = [NSString stringWithFormat:@"%ld",60 - self.count];
        self.count ++;
    }
}

- (UIView*)circleView{
    if (!_circleView) {
        _circleView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2 -  self.waveWidth/2, CGRectGetHeight(self.frame)/2 - self.waveWidth/2, self.waveWidth, self.waveWidth)];
        _circleView.layer.cornerRadius = CGRectGetWidth(_circleView.frame)/2;
        _circleView.layer.masksToBounds = YES;
        _circleView.backgroundColor = [UIColor clearColor];
        _circleView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    return _circleView;
}

- (NSTimer*)waterTimer{
    if (!_waterTimer) {
        _waterTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waterChangeAction:) userInfo:nil repeats:YES];
    }
    return _waterTimer;
}


@end
