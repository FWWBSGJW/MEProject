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

+ (NSDictionary *)userDataWithId:(NSString*)userId{
	NSString *urlStr = [NSString stringWithFormat:@"%@?userId=%@",kURL_login,userId];
	NSURL *url = [NSURL URLWithString:urlStr];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//	NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//	NSString *strr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSDictionary *dic = [data objectFromJSONData];
	return dic;
}

+ (NSDictionary *)loginWith:(NSString *)username
				andPassword:(NSString *)password{
//	NSString *urlStr = [NSString stringWithFormat:@"%@?account=%@&password=%@",kURL_login,username,password];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@!login",kURL_login]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setTimeoutInterval:5];
	[request setHTTPMethod:@"POST"];
	
	NSString *body = [NSString stringWithFormat:@"userAccount=%@&userPass=%@",username,password];
	NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
	[request setHTTPBody:bodyData];

	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if (error) {
		NSLog(@"%@",error);
	}
	//test
//	NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//	NSLog(@“%@ by str",str,self);
	NSDictionary *dic = [data objectFromJSONData];
	if (error) {
		NSLog(@"%@",error);
		dic = @{@"success":@"no link"};
	}
	return dic;
}

- (id)init{
	if (self = [super init]) {
		
	}
	return self;
}


@end
