//
//  InfoHeaderTableViewCell.m
//  StudentManagement
//
//  Created by Kitty on 17/2/22.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "InfoHeaderTableViewCell.h"

@interface InfoHeaderTableViewCell ()

@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *stuLabel;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,strong) UILabel *operateLabel;

@end

@implementation InfoHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/*
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = SETCOLOR(150, 210, 166, 1);
        _timeLabel.text = @"时间";
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.greaterThanOrEqualTo(@100);
            make.height.equalTo(self.contentView.mas_height);
            make.left.equalTo(@0);
            make.top.equalTo(@0);
        }];
        
        _stuLabel = [[UILabel alloc] init];
        _stuLabel.backgroundColor = SETCOLOR(150, 210, 166, 1);
        _stuLabel.text = @"学生";
        _stuLabel.textColor = [UIColor whiteColor];
        _stuLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_stuLabel];
        [_stuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.greaterThanOrEqualTo(@100);
            make.height.equalTo(self.contentView.mas_height);
            make.left.equalTo(_timeLabel.mas_right).with.offset(1);
            make.top.equalTo(_timeLabel.mas_top);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = SETCOLOR(150, 210, 166, 1);
        _nameLabel.text = @"文件名";
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@208);
            make.height.equalTo(self.contentView.mas_height);
            make.left.equalTo(_stuLabel.mas_right).with.offset(1);
            make.top.equalTo(_timeLabel.mas_top);
        }];
        
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.backgroundColor = SETCOLOR(150, 210, 166, 1);
        _stateLabel.text = @"状态";
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_stateLabel];
        [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.greaterThanOrEqualTo(@100);
            make.height.equalTo(self.contentView.mas_height);
            make.left.equalTo(_nameLabel.mas_right).with.offset(1);
            make.top.equalTo(_timeLabel.mas_top);
        }];
        
        _operateLabel = [[UILabel alloc] init];
        _operateLabel.backgroundColor = SETCOLOR(150, 210, 166, 1);
        _operateLabel.text = @"操作";
        _operateLabel.textColor = [UIColor whiteColor];
        _operateLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_operateLabel];
        [_operateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.greaterThanOrEqualTo(@100);
            make.height.equalTo(self.contentView.mas_height);
            make.left.equalTo(_stateLabel.mas_right).with.offset(1);
            make.top.equalTo(_timeLabel.mas_top);
            make.right.equalTo(@0);
        }];
    }
    
    return self;
}
 */

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
