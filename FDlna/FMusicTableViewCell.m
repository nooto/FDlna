//
//  FMusicTableViewCell.m
//  FDlna
//
//  Created by GaoAng on 2019/3/18.
//  Copyright © 2019年 Self.work. All rights reserved.
//

#import "FMusicTableViewCell.h"
#import "SOTools.h"

@interface FMusicTableViewCell()
@property (nonatomic, strong) UILabel *mTextLabel;
@end

@implementation FMusicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self.contentView addSubview:self.mTextLabel];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMItem:(MPMediaItem *)mItem{
    _mItem = mItem;
    [self.mTextLabel setText:mItem.title];
}


- (UILabel*)mTextLabel{
    if (!_mTextLabel) {
        _mTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_W/2, 30)];
        [_mTextLabel setFont:[UIFont systemFontOfSize:14]];
        [_mTextLabel setTextColor:[UIColor lightGrayColor]];
    }
    return _mTextLabel;
}

@end
