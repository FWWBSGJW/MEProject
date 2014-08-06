//
//  UserInfo.m
//  Online_learning
//
//  Created by qf on 14/7/7.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import "UserInfo.h"
#import "OLNetManager.h"
#define Test
@interface UserInfo ()
@end

@implementation UserInfo



- (id)init{
	if (self = [super init]) {
		_data		= nil;
		_userId		= @"1";
		_isLogin	= NO;
		_account	= nil;
		_name		= nil;
		_sex		= NO;
//		_image		= nil;
		_imageUrl	= nil;
		_describe	= nil;
		_lcourses	= [[NSMutableArray alloc] initWithCapacity:42];
		_ccourses	= [[NSMutableArray alloc] initWithCapacity:42];
		_bcourses	= [[NSMutableArray alloc] initWithCapacity:42];
		_focus		= [[NSMutableArray alloc] initWithCapacity:42];
		_focused	= [[NSMutableArray alloc] initWithCapacity:42];
		_questions	= [[NSMutableArray alloc] initWithCapacity:42];
		_answers	= [[NSMutableArray alloc] initWithCapacity:42];
		_testcollection	= [[NSMutableArray alloc] initWithCapacity:42];
		[self lastUserInfo];  //初始化时判断沙盒中是否存在数据 并设置数据
	}
	return self;
}

- (id)initWithUserId:(NSString *)userId{
	if (self = [super init]) {
		_data		= [[OLNetManager userDataWithId:userId] objectForKey:@"result"];
		_userId		= nil;
		_account	= nil;
		_name		= nil;
		_sex		= NO;
		_imageUrl	= nil;
		_describe	= nil;
		_lcourses	= [[NSMutableArray alloc] initWithCapacity:42];
		_ccourses	= [[NSMutableArray alloc] initWithCapacity:42];
		_bcourses	= [[NSMutableArray alloc] initWithCapacity:42];
		_focus		= [[NSMutableArray alloc] initWithCapacity:42];
		_focused	= [[NSMutableArray alloc] initWithCapacity:42];
		_questions	= [[NSMutableArray alloc] initWithCapacity:42];
		_answers	= [[NSMutableArray alloc] initWithCapacity:42];
		_testcollection = [[NSMutableArray alloc] initWithCapacity:42];

		[self setAllData];
	}
	return self;
}

- (void)setAllData{
	if (_data) {
		_userId		= [_data objectForKey:@"userId"];
		_account	= [_data objectForKey:@"userAccount"];
		_name		= [_data objectForKey:@"userName"];
		_sex		= [[_data objectForKey:@"userSex"] boolValue];
		_imageUrl	= [_data objectForKey:@"userPortrait"];
		_describe	= [_data objectForKey:@"userSign"];
		[_lcourses	addObjectsFromArray:[_data objectForKey:@"lcourses"]];
		[_ccourses  addObjectsFromArray:[_data objectForKey:@"ccourses"]];
		[_bcourses  addObjectsFromArray:[_data objectForKey:@"bcourses"]];
		[_focus		addObjectsFromArray:[_data objectForKey:@"focus"]];
		[_focused	addObjectsFromArray:[_data objectForKey:@"focused"]];
		[_questions addObjectsFromArray:[_data objectForKey:@"questions"]];
		[_answers	addObjectsFromArray:[_data objectForKey:@"answers"]];
		[_testcollection addObjectsFromArray:[_data objectForKey:@"testcollection"]];
	}
}

- (void)removeArrayData{
	[_lcourses removeAllObjects];
	[_ccourses removeAllObjects];
	[_bcourses removeAllObjects];
	[_focus removeAllObjects];
	[_focused removeAllObjects];
	[_questions removeAllObjects];
	[_answers removeAllObjects];
	[_testcollection removeAllObjects];
}

- (BOOL)userLogout{
	if (_isLogin == YES) {
		_data		= nil;
		
		_isLogin	= NO;
		_account	= nil;
		_name		= nil;
		_sex		= NO;
//		_image		= nil;
		_imageUrl	= nil;
		_describe	= nil;
		[self removeArrayData];
#ifdef Test
		return YES;
#endif
		[self saveUserStatus];
		return YES;
	}
	return NO;
}

//登陆 进行网络请求
- (BOOL)userLoginWith:(NSString *)userName andPassword:(NSString *)passWord{
	/*test*/
#ifdef Test
	if ([userName isEqualToString:@"1"] && [passWord isEqualToString:@"1"]) {
		[self lastUserInfo];
		return YES;
	}else if([userName length] == 1 && [userName intValue] != 0){
		NSDictionary *dic = [[OLNetManager userDataWithId:userName] objectForKey:@"result"];
		_data = dic;
		[self setAllData];
		_isLogin = YES;
		[self saveInfoToDocument];
		return YES;
	}
#endif
//	NSDictionary *dic = [OLNetManager loginWith:userName andPassword:passWord succ:^(NSDictionary *successDict) {
//	}];
//	NSDictionary *dic = [OLNetManager userDataWithId:_userId];
	NSDictionary *dic = [OLNetManager loginWith:userName andPassword:passWord];
	NSString *suc= [dic objectForKey:@"success"];

	if ([suc isEqualToString:@"true"]) {
		_data = [dic objectForKey:@"result"];
		[self setAllData];
		_isLogin = YES;
		[self saveInfoToDocument];
		return YES;
	}else if([suc isEqualToString:@"no link"]){
		NSLog(@"no link OLNetWorking");
	}
	else{
		NSLog(@"user login is faliure by %@",self);
		return NO;
	}
	return NO;
}

- (BOOL)refresh{
	NSDictionary *dic = [OLNetManager userDataWithId:_userId];
	NSString *suc = [dic objectForKey:@"success"];
	
	if ([suc isEqualToString:@"true"]) {
		_data = dic[@"result"];
		[self removeArrayData];
		[self setAllData];
		[self saveInfoToDocument];
		return YES;
	}else {
		NSLog(@"user refresh is faliuser by %@",self);
		return NO;
	}
}

- (void)update{
	[OLNetManager userDataWithId:_userId];
}

- (BOOL)lastUserInfo{	//判断沙盒中是否存在用户信息
	if ([[NSFileManager defaultManager] fileExistsAtPath:[self userFilePath]]) {
		NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:[self userFilePath]];
		if ([[[userDic objectForKey:@"lastLogin"] objectForKey:@"isLogin"] isEqualToString:@"YES"]) {
			_data = [userDic objectForKey:@"userInfo"];
			[self setAllData];
			_isLogin = YES;
			return YES;
		}
	}
	return NO;
}

- (NSString *)userFilePath{
	static NSString *path = nil;
	if (!path) {
		NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
		NSString *doucumentsDirectiory = [storeFilePath objectAtIndex:0];
		path =[doucumentsDirectiory stringByAppendingPathComponent:@"user.plist"];
	}
	return path;
}
//保存登陆状态到沙盒中
- (void)saveUserStatus{
	static const NSString *statusKey = @"lastLogin";
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:[self userFilePath]];
	NSMutableDictionary *status = [dic objectForKey:statusKey];
	if (!status) {
		status = [[NSMutableDictionary alloc] initWithDictionary:@{@"isLogin":_isLogin?@"YES":@"NO"}];
		[dic setObject:status forKey:statusKey];
	}else{
		status[@"isLogin"] = _isLogin?@"YES":@"NO";
		dic[statusKey] = status;
	}
	[dic writeToFile:[self userFilePath] atomically:YES];
}

//保存数据到沙盒中
- (void)saveInfoToDocument{
    NSFileManager *file = [NSFileManager defaultManager];
    if ([file fileExistsAtPath:[self userFilePath]]){
		NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithContentsOfFile:[self userFilePath]];
		userDic[@"userInfo"] = _data;
		[userDic writeToFile:[self userFilePath] atomically:YES];
	}
    else {//若沙盒中没有
		NSMutableDictionary *userDic = [[NSMutableDictionary alloc] initWithCapacity:42];
		NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:_data];
		[userDic setObject:userInfo forKey:@"userInfo"];
		[userDic writeToFile:[self userFilePath] atomically:YES];
	}
	[self saveUserStatus];
}



















@end
