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
#define kURL_test @"http://172.16.54.199:8080/MobileEducation/userAction"
@interface OLNetManager(){
//	void(^succ)(NSDictionary *dic);
}

//@property (nonatomic,strong) NSMutableData *data;
@end

@implementation OLNetManager



+(NSData *)netRequestWithUrl:(NSString *)urlStr andPostBody:(NSString *)body{
	NSURL *url = [NSURL URLWithString:urlStr];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setTimeoutInterval:5];
	
	if (body) {
		[request setHTTPMethod:@"POST"];
		NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
		[request setHTTPBody:bodyData];
	}
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if (error) {
		NSLog(@"%@",error);
		return nil;
	}
//	NSLog(@"result = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	return data;
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

+ (NSDictionary *)userDataWithId:(NSString*)userId{
	NSString *urlStr = [NSString stringWithFormat:@"%@?userId=%@",kURL_login,userId];
//	NSURL *url = [NSURL URLWithString:urlStr];
//	NSURLRequest *request = [NSURLRequest requestWithURL:url];
//	NSURLResponse *response = nil;
//	NSError *error = nil;
//	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//	NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//	NSString *strr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//	NSDictionary *dic = [data objectFromJSONData];
	
	NSDictionary *dic = [[OLNetManager netRequestWithUrl:urlStr andPostBody:nil] objectFromJSONData];
	return dic;
}

+ (NSDictionary *)loginWith:(NSString *)username
				andPassword:(NSString *)password{
	NSString *urlStr = [NSString stringWithFormat:@"%@!login",kURL_login];
//	NSURL *url = [NSURL URLWithString:urlStr];
//	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//	[request setTimeoutInterval:5];
//	[request setHTTPMethod:@"POST"];
//	
	NSString *body = [NSString stringWithFormat:@"userAccount=%@&userPass=%@",username,password];
//	NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
//	[request setHTTPBody:bodyData];
//
//	NSURLResponse *response = nil;
//	NSError *error = nil;
//	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//	if (error) {
//		NSLog(@"%@",error);
//	}
	//test
//	NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//	NSLog(@“%@ by str",str,self);
	NSDictionary *dic = [[OLNetManager netRequestWithUrl:urlStr andPostBody:body] objectFromJSONData];
	if (!dic) {
		dic = @{@"success":@"no link"};
	}
	return dic;
}

+ (BOOL)deleteCollectionTestWithUserId:(NSString *)userId andTestId:(NSString *)testId{
	NSString *urlAsString = @"http://121.197.10.159:8080/MobileEducation/collecteTest";
    urlAsString = [urlAsString stringByAppendingString:[NSString stringWithFormat:@"?userId=%@&CId=%@", userId, testId]];
//    NSURL *url = [NSURL URLWithString:urlAsString];
//    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
//    [urlRequest setTimeoutInterval:30.0f];
//    [urlRequest setHTTPMethod:@"POST"];
    NSString *body = @"bodyParam1=BodyValue1&bodyParam2=BodyValue2";
//    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
//	
//	NSURLResponse *response = nil;
//	NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
//	if (error) {
//		NSLog(@"%@",error);
//	}
	
	NSDictionary *dic = [[OLNetManager netRequestWithUrl:urlAsString andPostBody:body] objectFromJSONData];
	return [dic objectForKey:@"success"];
}

+ (NSInteger)privateWithCourseID:(NSInteger)courseID andUserID:(NSString *)userID
{
    NSString *str = [kBaseURL stringByAppendingString:[NSString stringWithFormat:@"MobileEducation/collectionAction?userId=%@&CId=%ld",userID,(long)courseID]];
//    NSURL *url = [NSURL URLWithString:str];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.5f];
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
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
