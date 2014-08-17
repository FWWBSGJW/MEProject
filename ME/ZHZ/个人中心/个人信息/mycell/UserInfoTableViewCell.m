//
//  UserInfoTableViewCell.m
//  Online_learning
//
//  Created by qf on 14/7/9.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import "UserInfoTableViewCell.h"
#import "FocusTableViewController.h"
#import "UIImageView+WebCache.h"
#import "User.h"

@interface UserInfoTableViewCell ()
@property (nonatomic) User *user;
@end

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

- (void)setUser:(User *)user{
	_user = user;
	[self setAImage:_user.info.imageUrl
			   andName:_user.info.name
			 courseNum:[_user.info.lcourses count]
			  focusNum:[_user.info.focus count]
		 focusedNum:[_user.info.focused count]];
}

- (void)setAImage:(NSString *)imageUrl
		 andName:(NSString *)name
	   courseNum:(NSUInteger)num1
		focusNum:(NSUInteger)num2
	  focusedNum:(NSUInteger)num3{
	
	[_portrait setImageWithURL:[NSURL URLWithString:kUrl_image(imageUrl)] placeholderImage:[UIImage imageNamed:kDefault_portrait] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
		_user.info.portrait = image;
	}];
	_nameLabel.text = name;
	_courseNumLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)num1];
	_focusNumLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)num2];
	_focusedNumLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)num3];
}
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
