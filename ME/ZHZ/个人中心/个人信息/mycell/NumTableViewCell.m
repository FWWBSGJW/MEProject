//
//  NumTableViewCell.m
//  Online_learning
//
//  Created by qf on 14/7/10.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import "NumTableViewCell.h"

@implementation NumTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NumCell" owner:self options:nil];
	self = nib[0];
	return self;
}

- (id)init{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NumCell" owner:self options:nil];
	self = nib[0];
	return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
