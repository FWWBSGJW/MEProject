//
//  UserInfo.m
//  Online_learning
//
//  Created by qf on 14/7/7.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import "UserInfo.h"
#import "OLNetManager.h"
#define kURL_login
@interface UserInfo ()
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSDictionary *data;
@end

@implementation UserInfo

- (id)init{
	if (self = [super init]) {
		_data		= nil;
		
		_isLogin	= NO;
		_account	= nil;
		_name		= nil;
		_sex		= nil;
		_image		= nil;
		_imageUrl	= nil;
		_describe	= nil;
		_lcourses	= [[NSMutableArray alloc] initWithCapacity:42];
		_ccourses	= [[NSMutableArray alloc] initWithCapacity:42];
		_bcourses	= [[NSMutableArray alloc] initWithCapacity:42];
		_focus		= [[NSMutableArray alloc] initWithCapacity:42];
		_focused	= [[NSMutableArray alloc] initWithCapacity:42];
		_questions	= [[NSMutableArray alloc] initWithCapacity:42];
		_answers	= [[NSMutableArray alloc] initWithCapacity:42];
		[self lastUserInfo];  //初始化时判断沙盒中是否存在数据
	}
	return self;
}

- (void)setAllData{
	if (_data) {
		_account	= [_data objectForKey:@"account"];
		_name		= [_data objectForKey:@"name"];
		_sex		= [_data objectForKey:@"sex"];
		_imageUrl	= [_data objectForKey:@"imageUrl"];
		_image		= [UIImage imageNamed:_imageUrl];
		_describe	= [_data objectForKey:@"describe"];
		[_lcourses	addObjectsFromArray:[_data objectForKey:@"lcourses"]];
		[_ccourses  addObjectsFromArray:[_data objectForKey:@"ccourses"]];
		[_bcourses  addObjectsFromArray:[_data objectForKey:@"bcourses"]];
		[_focus		addObjectsFromArray:[_data objectForKey:@"focus"]];
		[_focused	addObjectsFromArray:[_data objectForKey:@"focused"]];
		[_questions addObjectsFromArray:[_data objectForKey:@"questions"]];
		[_answers	addObjectsFromArray:[_data objectForKey:@"answers"]];
	}
}

- (BOOL)userLogout{
	if (_isLogin == YES) {
		_data		= nil;
		
		_isLogin	= NO;
		_account	= nil;
		_name		= nil;
		_sex		= nil;
		_image		= nil;
		_imageUrl	= nil;
		_describe	= nil;
		[_lcourses removeAllObjects];
		[_ccourses removeAllObjects];
		[_bcourses removeAllObjects];
		[_focus removeAllObjects];
		[_focused removeAllObjects];
		[_questions removeAllObjects];
		[_answers removeAllObjects];
		[self saveUserStatus];
		return YES;
	}
	return NO;
}

//登陆 进行网络请求
- (BOOL)userLoginWith:(NSString *)userName andPassword:(NSString *)passWord{
	/*test*/

#define Test 1
#if Test
	if ([userName isEqualToString:@"admin"] && [passWord isEqualToString:@"123456"]) {
		NSBundle *bundle = [NSBundle mainBundle];
		NSURL *sourceUrl = [bundle URLForResource:@"User" withExtension:@"plist"];
		NSDictionary *source = [NSDictionary dictionaryWithContentsOfURL:sourceUrl];
		_data = [source objectForKey:@"userInfo"];
		[self setAllData];
		_isLogin = YES;
		[self saveInfoToDocument];
		return YES;
	}
#else
	NSDictionary *dic = @{@"username":userName,@"password":passWord};
	[OLNetManager requestWith:dic url:kURL_login method:@"POST" parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
		_data = successDict;
	} failure:^(NSDictionary *failDict, NSError *error) {
//		_data = failDict;
		NSLog(@"net request fail");
	}];
#endif
	return NO;
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
