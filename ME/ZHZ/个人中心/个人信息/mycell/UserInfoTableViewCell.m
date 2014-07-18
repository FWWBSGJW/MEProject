//
//  UserInfoTableViewCell.m
//  Online_learning
//
//  Created by qf on 14/7/9.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import "UserInfoTableViewCell.h"
#import "FocusTableViewController.h"

@implementation UserInfoTableViewCell

- (void)awakeFromNib
{
    // Initialization code
//	[self init];
}

- (id)initWithFrame:(CGRect)frame{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserInfoCell" owner:self options:nil];
	self = nib[0];
	return self;
}

- (id)init{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserInfoCell" owner:self options:nil];
	self = nib[0];
	
	return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	for (UITouch *touch in touches) {
		CGPoint point = [touch locationInView:self];
		if (point.y >=33 && point.y <=90 && point.x >=98) {
			if (point.x <= 156) {
				[self.delegate courseLabelTouchEvent];
			}else if(point.x <= 230){
				[self.delegate focusLabelTouchEvent];
			}else{
				[self.delegate focusedLabelTouchEvent];
			}
		}
	}
}


- (void)setAImage:(UIImage *)image
		 andName:(NSString *)name
	   courseNum:(NSUInteger)num1
		focusNum:(NSUInteger)num2
	  focusedNum:(NSUInteger)num3{
	_portrait.image = image;
	_nameLabel.text = name;
	_courseNumLabel.text = [NSString stringWithFormat:@"%d",num1];
	_focusNumLabel.text = [NSString stringWithFormat:@"%d",num2];
	_focusedNumLabel.text = [NSString stringWithFormat:@"%d",num3];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
