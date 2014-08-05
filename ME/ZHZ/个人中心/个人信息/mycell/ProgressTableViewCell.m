//
//  GuageTableViewCell.m
//  Online_learning
//
//  Created by qf on 14/7/10.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import "ProgressTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ProgressTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProgressCell" owner:self options:nil];
		self = nib[0];
		self.progressView = [[ZDProgressView alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + 2, 204, 25)];
		[self.contentView addSubview:self.progressView];
		self.progressView.backgroundColor = [UIColor blackColor];
		self.progressView.noColor = [UIColor whiteColor];
		self.progressView.prsColor = [UIColor lightGrayColor];
		self.highlighted = NO;
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProgressCell" owner:self options:nil];
	self = nib[0];
	self.progressView = [[ZDProgressView alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + 2, 204, 25)];
	[self.contentView addSubview:self.progressView];
	self.progressView.backgroundColor = [UIColor blackColor];
	self.progressView.noColor = [UIColor whiteColor];
	self.progressView.prsColor = [UIColor lightGrayColor];
	self.highlighted = NO;
	return self;
}

- (void)cellWithCourse:(NSDictionary *)course{
	self.nameLabel.text = [course objectForKey:@"cName"];
	[self.courseImage setImageWithURL:[NSURL URLWithString:kUrl_image([course objectForKey:@"cPic"])]];
//	NSLog(@"%@",kUrl_image([course objectForKey:@"cPic"]));
	self.progressView.progress = [[course objectForKey:@"progress"] doubleValue];
	self.progressView.text = [NSString stringWithFormat:@"%.2lf%%",[[course objectForKey:@"progress"] doubleValue]*100];
	self.courseId = [course objectForKey:@"cid"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
