//
//  UserLogin.m
//  Online_learning
//
//  Created by qf on 14/7/9.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import "User.h"
#import "SynthesizeSingleton.h"
#import "LoginViewController.h"

@interface User ()
@property (nonatomic,strong) LoginViewController *lvc;
@end

@implementation User

SYNTHESIZE_SINGLETON_FOR_CLASS(User);
- (id)init{
	if (self = [super init]) {
		_info = [[UserInfo alloc] init];
	}
	return self;
}

-(id)initUserWithUserId:(NSString *)userid{
	if (self = [super init]) {
		_info = [[UserInfo alloc] initWithUserId:userid];
	}
	return self;
}
- (void)gotoUserLoginFrom:(UIViewController *)fromVC{
	_lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
	_lvc.showCencel = NO;
	_currentVC = fromVC;
	if (_currentVC) {
		[_currentVC.navigationController pushViewController:_lvc animated:YES];
	}else{
		NSLog(@"no viewController to push");
	}
}

-(BOOL)refreshInfo{
	return [_info refresh];
}

- (void)logout{
	[_info userLogout];	//用户登出
}

- (BOOL)loginWith:(NSString *)username Password:(NSString *)pwd {

	if (!_info.isLogin) {
		BOOL result = [_info userLoginWith:username andPassword:pwd];
		if (result) {
			UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"登陆成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
			[success show];
			if (_currentVC) {
				[_lvc.navigationController popToViewController:_currentVC animated:YES];
			}
			return YES;
		}else{
			UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"登陆失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
			[failure show];
			//返回一些错误提示
#warning 返回一些错误提示  账号不存在 密码错误
		}
	}
	return NO;
}





@end
