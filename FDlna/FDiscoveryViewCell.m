//
//  FDiscoveryViewCell.m
//  FDlna
//
//  Created by GaoAng on 2019/3/22.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import "FDiscoveryViewCell.h"
#import "SOTools.h"
#import "SOBaseCode.h"
#import  <Masonry.h>
#import <StepOHelper.h>
@interface FDiscoveryViewCell()
@property (nonatomic, strong) UILabel *mTextLabel;
@property (nonatomic, strong) UILabel *mUUIDLabel;
@property (nonatomic, strong) UILabel *mCurrentDevcielabel;
@end

@implementation FDiscoveryViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self.contentView addSubview:self.mTextLabel];
    [self.contentView addSubview:self.mUUIDLabel];
    [self.contentView addSubview:self.mCurrentDevcielabel];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.mCurrentDevcielabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.5f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@(60));
        make.right.equalTo(self.mas_right).offset(- 15);
    }];
    
    [self.mTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.35f);
        make.bottom.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.mCurrentDevcielabel.mas_left).offset(- 15);
    }];

    [self.mUUIDLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY).offset(5);
        make.right.left.equalTo(self.mTextLabel);
        make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.35f);
    }];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setMDeviceDict:(NSDictionary *)mDeviceDict isCurrentDevice:(BOOL)isCurrentDevice{
    _mDeviceDict = mDeviceDict;
    [self.mTextLabel setText:mDeviceDict[kKeyDeviceName]];
    [self.mUUIDLabel  setText:mDeviceDict[kKeyDeviceUUID]];
    self.mCurrentDevcielabel.hidden = !isCurrentDevice;
}

- (UILabel*)mTextLabel{
    if (!_mTextLabel) {
        _mTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_W/2, 30)];
        [_mTextLabel setFont:[UIFont systemFontOfSize:17]];
        [_mTextLabel setTextColor:[UIColor whiteColor]];
    }
    return _mTextLabel;
}

- (UILabel*)mUUIDLabel{
    if (!_mUUIDLabel) {
        _mUUIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_W/2, 30)];
        [_mUUIDLabel setFont:[UIFont systemFontOfSize:13]];
        [_mUUIDLabel setTextColor:[UIColor colorWithWhite:1.f alpha:0.8f]];
    }
    return _mUUIDLabel;
}
- (UILabel*)mCurrentDevcielabel{
    if (!_mCurrentDevcielabel) {
        _mCurrentDevcielabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_W/2, 30)];
        [_mCurrentDevcielabel setFont:[UIFont systemFontOfSize:13]];
        [_mCurrentDevcielabel setText:@"当前设备"];
        [_mCurrentDevcielabel setTextColor:UIColorFromHexString(@"#FFDA00")];
    }
    return _mCurrentDevcielabel;
}

@end
