//
//  OLNetManager.m
//  Online_learning
//
//  Created by qf on 14/7/9.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import "OLNetManager.h"

#define NetworkTimeout 30
#define kURL_login @"http://121.197.10.159:8080/MobileEducation/userAction?userId=1"

@interface OLNetManager(){
//	void(^succ)(NSDictionary *dic);
}

//@property (nonatomic,strong) NSMutableData *data;
@end

@implementation OLNetManager


- (NSDictionary *)loginWith:(NSString *)username
				andPassword:(NSString *)password
					   succ:(SUCCESSBLOCK)success{
//	NSString *urlStr = [NSString stringWithFormat:@"%@?account=%@&password=%@",kURL_login,username,password];
	NSURL *url = [NSURL URLWithString:kURL_login];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
//	[NSURLConnection connectionWithRequest:request delegate:self];
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
#warning 编码方式
	NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSDictionary *dic = [str objectFromJSONString];
	return [dic objectForKey:@"result"];
}
#pragma mark - url connection data delegate

//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//	[self.data appendData:data];
//}

//- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
//	NSString *str = [[NSString alloc] initWithData:_data encoding:NSASCIIStringEncoding];
//	NSDictionary *dic = [str objectFromJSONString];
//	succ(dic);
//}

- (id)init{
	if (self = [super init]) {
		
	}
	return self;
}


@end
