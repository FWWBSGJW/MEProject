//
//  UserLogin.h
//  Online_learning
//
//  Created by qf on 14/7/9.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
@interface User : NSObject<UIAlertViewDelegate>
@property (nonatomic,strong) UserInfo *info;
@property (nonatomic)		BOOL justLogin;
@property (nonatomic)		BOOL justLogout;
@property (nonatomic)		BOOL havaChange;
@property (nonatomic)		BOOL refreshMe;
@property (nonatomic,strong) UIViewController *currentVC;

/*	
	
 */
- (id)initUserWithUserId:(NSInteger)userid;
- (void)gotoUserLoginFrom:(UIViewController *)currentViewController;
- (BOOL)loginWith:(NSString *)username Password:(NSString *)pwd;//调出登陆界面
- (BOOL)logout;
+ (User *)sharedUser;
- (BOOL)refreshInfo;
@end
