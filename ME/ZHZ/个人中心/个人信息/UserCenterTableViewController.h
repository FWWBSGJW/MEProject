//
//  UserCenterViewControllerTableViewController.h
//  Online_learning
//
//  Created by qf on 14/7/9.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoTableViewCell.h"
#import "User.h"
/**
 *			用户个人中心
 *			1.GroupTalbe
 */
@interface UserCenterTableViewController : UITableViewController<UserInfoTableViewCellDelegate>
@property (nonatomic,strong) User *user;
- (id)initWithUserId:(NSString *)userId;
@end
