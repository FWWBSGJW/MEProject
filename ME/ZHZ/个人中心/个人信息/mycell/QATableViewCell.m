//
//  QATableViewCell.m
//  ME
//
//  Created by qf on 14/8/5.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "QATableViewCell.h"
#import "UILabel+dynamicSizeMe.h"
@interface QATableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end


@implementation QATableViewCell

- (id)initWithFrame:(CGRect)frame{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QATableViewCell" owner:self options:nil];
	self = nib[0];
	return self;
}

- (id)init{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QATableViewCell" owner:self options:nil];
	self = nib[0];
	return self;
}

- (void)setUI{
	_titleLabel.text = _title;
	_dateLabel.text = _date;
	[_dateLabel resizeToFit];
	_contentLabel.text = _content;
	_contentLabel.textColor = [UIColor lightGrayColor];
	[_contentLabel resizeToFit];
	
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
