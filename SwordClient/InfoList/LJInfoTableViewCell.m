//
//  LJInfoTableViewCell.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/8.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJInfoTableViewCell.h"

@interface LJInfoTableViewCell ()

@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation LJInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.iconView];
    }
    return self;
}

- (void)configUIWithDic:(NSDictionary *)dic {
    self.msgLabel.text = [dic objectForKey:@"title"];
    self.timeLabel.text = [dic objectForKey:@"c_time"];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"pic"]] placeholderImage:Image(@"")];
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [UILabel new];
        _msgLabel.frame = CGRectMake(15, 16, kScreenWidth - 15 - 100, 20);
        _msgLabel.textColor = [UIColor colorWithHexString:@"454545"];
        _msgLabel.font = Font(15);
    }
    return _msgLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.frame = CGRectMake(15, 40, kScreenWidth - 15 - 100, 15);
        _timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _timeLabel.font = Font(10);
    }
    return _timeLabel;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.frame = CGRectMake(kScreenWidth - 80 - 10, 9, 80, 50);
    }
    return _iconView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
