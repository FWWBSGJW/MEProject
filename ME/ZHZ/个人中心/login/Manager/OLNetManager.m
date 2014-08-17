//
//  OLNetManager.m
//  Online_learning
//
//  Created by qf on 14/7/9.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import "OLNetManager.h"

#define NetworkTimeout 30
#define kURL_login @"http://121.197.10.159:8080/MobileEducation/userAction"
#define kURL_logout @"http://121.197.10.159:8080/MobileEducation/logout"
#define kURL_test @"http://172.16.54.199:8080/MobileEducation/userAction"
@interface OLNetManager(){
}
@end

@implementation OLNetManager


+(NSData *)netRequestWithUrl:(NSString *)urlStr andPostBody:(NSString *)strbody{

	NSData *bodyData = [strbody dataUsingEncoding:NSUTF8StringEncoding];
	return [OLNetManager netRequestWithUrl:urlStr andPostDataBody:bodyData];
}

+(NSData *)netRequestWithUrl:(NSString *)urlStr andPostDataBody:(NSData *)body{
	NSURL *url = [NSURL URLWithString:urlStr];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setTimeoutInterval:5];
	
	if (body) {
		[request setHTTPMethod:@"POST"];
		[request setHTTPBody:body];
	}
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if (error) {
		NSLog(@"%@",error);
		return nil;
	}
	NSLog(@"result = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	return data;
}

+ (NSInteger)focusUserWithUserId:(NSInteger)userId{
	NSString *urlStr = [NSString stringWithFormat:@"%@MobileEducation/concernUser?userId=%li",kBaseURL,userId];
	NSDictionary *dic = [[OLNetManager netRequestWithUrl:urlStr andPostBody:nil] objectFromJSONData];
	return [[dic objectForKey:@"success"] integerValue];
}

+ (NSInteger)userRegisterWithUserName:(NSString *)username
						  userAccount:(NSString *)account
						   andUserPwd:(NSString *)pwd{
	NSString *urlstr = [NSString stringWithFormat:@"%@MobileEducation/register",kBaseURL];
	NSString *body = [NSString stringWithFormat:@"userName=%@&userPass=%@&userAccount=%@",username,pwd,account];
//	NSString *url = [NSString stringWithFormat:@"%@?%@",urlstr,body];
	NSDictionary *dic = [[OLNetManager netRequestWithUrl:urlstr andPostBody:body] objectFromJSONData];
	return [[dic objectForKey:@"success"] integerValue];
}

+ (NSDictionary *)userDataWithId:(NSInteger)userId{
	NSString *urlStr = [NSString stringWithFormat:@"%@?userId=%li",kURL_login,(long)userId];
	NSDictionary *dic = [[OLNetManager netRequestWithUrl:urlStr andPostBody:nil] objectFromJSONData];
	return dic;
}

+ (NSDictionary *)logout{
	NSDictionary *dic = [[OLNetManager netRequestWithUrl:kURL_logout andPostBody:nil] objectFromJSONData];
	return dic;
}

+ (NSDictionary *)loginWith:(NSString *)username
				andPassword:(NSString *)password{
	NSString *urlStr = [NSString stringWithFormat:@"%@!login",kURL_login];
	NSString *body = [NSString stringWithFormat:@"userAccount=%@&userPass=%@",username,password];
	NSDictionary *dic = [[OLNetManager netRequestWithUrl:urlStr andPostBody:body] objectFromJSONData];
	if (!dic) {
		dic = @{@"success":@"no link"};
	}
	return dic;
}

+ (BOOL)deleteCollectionTestWithUserId:(NSInteger)userId andTestId:(NSString *)testId{
	NSString *urlAsString = @"http://121.197.10.159:8080/MobileEducation/collecteTest";
    urlAsString = [urlAsString stringByAppendingString:[NSString stringWithFormat:@"?userId=%li&CId=%@", (long)userId, testId]];
    NSString *body = @"bodyParam1=BodyValue1&bodyParam2=BodyValue2";
	
	NSDictionary *dic = [[OLNetManager netRequestWithUrl:urlAsString andPostBody:body] objectFromJSONData];
	return [[dic objectForKey:@"success"] boolValue];
}

+ (NSInteger)privateWithCourseID:(NSInteger)courseID andUserID:(NSInteger)userID
{
    NSString *str = [kBaseURL stringByAppendingString:[NSString stringWithFormat:@"MobileEducation/collectionAction?userId=%i&CId=%ld",userID,(long)courseID]];
	NSData *data = [OLNetManager netRequestWithUrl:str andPostBody:nil];
    if (data != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        return [dic[@"success"] integerValue];
        
    } else{
        NSLog(@"空数据");
        return 0;
    }
}
- (id)init{
	if (self = [super init]) {
		
	}
	return self;
}


@end
