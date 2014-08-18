//
//  UserInfoTableViewCell.h
//  Online_learning
//
//  Created by qf on 14/7/9.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@protocol UserInfoTableViewCellDelegate <NSObject>
- (void)courseLabelTouchEvent;
- (void)focusLabelTouchEvent;
- (void)focusedLabelTouchEvent;
@end

@interface UserInfoTableViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UIImageView *portrait;//头像
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *courseNumLabel;
@property (nonatomic,weak) IBOutlet UILabel *focusNumLabel; //关注
@property (nonatomic,weak) IBOutlet UILabel *focusedNumLabel;//被关注
@property (nonatomic,weak) IBOutlet UILabel	*pointsLabel;	//积分
@property (nonatomic,weak) id<UserInfoTableViewCellDelegate> delegate;
- (void)setAImage:(NSString *)imageUrl
		 andName:(NSString *)name
	   courseNum:(NSUInteger)num1
		focusNum:(NSUInteger)num2
	  focusedNum:(NSUInteger)num3
		   points:(NSInteger) num4;
- (void)setUser:(User *)_user;
@end

