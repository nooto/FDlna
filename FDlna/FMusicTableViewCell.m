//
//  FMusicTableViewCell.m
//  FDlna
//
//  Created by GaoAng on 2019/3/18.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import "FMusicTableViewCell.h"
#import "SOTools.h"
#import <StepOHelper.h>
#import <Masonry.h>
@interface FMusicTableViewCell()
@property (nonatomic, strong) UILabel *mTextLabel;
@property (nonatomic, strong) UILabel *mDetailLabel;
@property (nonatomic, strong) UILabel *mArtisLabel;
//@property (nonatomic, strong) UIButton *mPlayButton;
@property (nonatomic, strong) UIImageView *mPlayImageView;

@end

@implementation FMusicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self.contentView addSubview:self.mPlayImageView];
    [self.contentView addSubview:self.mTextLabel];
    [self.contentView addSubview:self.mDetailLabel];
    [self.contentView addSubview:self.mArtisLabel];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)playAction:(UIButton*)sender{
    
}


- (void)layoutSubviews{
    [super layoutSubviews];

    [self.mPlayImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.contentView.mas_height).multipliedBy(0.5f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];

    if (self.mDetailLabel.text.length) {
        [self.mTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.35f);
            make.bottom.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.right.equalTo(self.mPlayImageView.mas_left).offset(- 15);
        }];
        
        [self.mDetailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.mTextLabel);
            make.width.equalTo(self.mTextLabel.mas_width).multipliedBy(0.667);
            make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.35f);
        }];
        
        [self.mArtisLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(self.mDetailLabel);
            make.right.equalTo(self.mTextLabel.mas_right);
            make.left.equalTo(self.mDetailLabel.mas_right);
        }];
    }
    else{
        [self.mArtisLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(self.contentView.mas_width).multipliedBy(0.25);
            make.height.equalTo(self.contentView.mas_width).multipliedBy(0.5);
            make.right.equalTo(self.mPlayImageView.mas_left).offset(- 15);
        }];

        [self.mTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.35f);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.right.equalTo(self.mArtisLabel.mas_right).offset(- 30);
        }];
        
        [self.mDetailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.mTextLabel);
            make.width.equalTo(self.mTextLabel.mas_width).multipliedBy(0.667);
            make.height.mas_equalTo(0);
        }];
    }
}

- (void)loarCellWithMediaitem:(MPMediaItem*)mItem songStatus:(SOSongStatus)status{
    _mItem = mItem;
    [self.mTextLabel setText:mItem.title];
    NSMutableString *detailString = [[NSMutableString alloc] initWithString:@""];
    if (mItem.albumTitle.length) {
        [detailString appendString:@"专辑:"];
        [detailString appendString:mItem.albumTitle];
    }
    
    if (mItem.releaseDate) {
        [detailString appendString:@"发行时间:"];
        [detailString appendString:mItem.albumTitle];
    }
    [self.mDetailLabel setText:detailString];
    [self.mArtisLabel setText:mItem.artist];

    self.mPlayImageView.hidden = YES;
    [self.mPlayImageView stopAnimating];
    if (status == SOSongStatu_Playing){
        NSLog(@"loarCellWithMediaitem: %@, %ld", mItem.artist, (long)status);

        self.mPlayImageView.hidden = NO;
        [self.mPlayImageView startAnimating];
//        [self.mPlayImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.height.equalTo(self.contentView.mas_height).multipliedBy(0.5f);
//        }];
    }
}


- (UILabel*)mTextLabel{
    if (!_mTextLabel) {
        _mTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_W/2, 30)];
        [_mTextLabel setFont:[UIFont systemFontOfSize:17]];
        [_mTextLabel setTextColor:[UIColor whiteColor]];
    }
    return _mTextLabel;
}

- (UILabel*)mDetailLabel{
    if (!_mDetailLabel) {
        _mDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_W/2, 30)];
        [_mDetailLabel setFont:[UIFont systemFontOfSize:13]];
        [_mDetailLabel setTextColor:[UIColor colorWithWhite:1.f alpha:0.8f]];
    }
    return _mDetailLabel;
}

- (UILabel*)mArtisLabel{
    if (!_mArtisLabel) {
        _mArtisLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_W/2, 30)];
        [_mArtisLabel setFont:[UIFont systemFontOfSize:13]];
        _mArtisLabel.textAlignment = NSTextAlignmentRight;
        [_mArtisLabel setTextColor:[UIColor colorWithWhite:1.f alpha:0.8f]];
    }
    return _mArtisLabel;
}


- (UIImageView*)mPlayImageView{
    if (!_mPlayImageView) {
        _mPlayImageView = [[UIImageView alloc] init];
        NSMutableArray *imageArray = [NSMutableArray array];
        NSArray *imageNameArray = @[@"icon_music_refresh",@"icon_music_refresh1",@"icon_music_refresh2"];
        for (NSInteger i = 0; i < imageNameArray.count; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%@",imageNameArray[i]];
            UIImage *image = [UIImage imageNamed:imageName];
            if (image) {
                [imageArray addObject:image];
            }
        }
        [_mPlayImageView setAnimationDuration:.3f];
        [_mPlayImageView setAnimationImages:imageArray];
        _mPlayImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _mPlayImageView.layer.borderWidth = 0.3f;
        _mPlayImageView.layer.cornerRadius = 5.f;
        _mPlayImageView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    }
    return _mPlayImageView;
}


@end
