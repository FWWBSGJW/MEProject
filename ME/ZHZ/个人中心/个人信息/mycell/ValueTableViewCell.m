//
//  ValueTableViewCell.m
//  ME
//
//  Created by qf on 14/8/18.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "ValueTableViewCell.h"

@interface ValueTableViewCell ()

@end

@implementation ValueTableViewCell

- (id)initWithFrame:(CGRect)frame{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ValueTableViewCell" owner:self options:nil];
	self = nib[0];
	return self;
}

- (id)initWithValue:(NSInteger)value andName:(NSString *)name{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ValueTableViewCell" owner:self options:nil];
	self = nib[0];

	_nameLabel.text = name;
	self.progressView = [[ZDProgressView alloc] initWithFrame:CGRectMake(_nameLabel.left + 50, _nameLabel.bottom + 2, 250, 18)];
	[self.contentView addSubview:self.progressView];
	self.progressView.backgroundColor = [UIColor blackColor];
	self.progressView.noColor = [UIColor whiteColor];
	self.progressView.prsColor = RGBCOLOR(68, 234, 243);
	self.progressView.progress = value / 2500.0;
	self.progressView.text = [NSString stringWithFormat:@"战斗力:%i",value];
	return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
