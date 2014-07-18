//
//  GuageTableViewCell.m
//  Online_learning
//
//  Created by qf on 14/7/10.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import "ProgressTableViewCell.h"

@implementation ProgressTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}


- (id)initWithFrame:(CGRect)frame{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProgressCell" owner:self options:nil];
	self = nib[0];
	self.progressView = [[ZDProgressView alloc] initWithFrame:CGRectMake(96, 42, 204, 30)];
	[self.contentView addSubview:self.progressView];
	self.progressView.backgroundColor = [UIColor blackColor];
	self.progressView.noColor = [UIColor whiteColor];
	self.progressView.prsColor = [UIColor lightGrayColor];
	self.highlighted = NO;
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
