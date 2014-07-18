//
//  OLNetManager.m
//  Online_learning
//
//  Created by qf on 14/7/9.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import "OLNetManager.h"

#define NetworkTimeout 30
@implementation OLNetManager

+ (void)requestWith:(NSDictionary *)aDict
				url:(NSString *)aUrl
			 method:(NSString *)aMethod
	 parameEncoding:(AFHTTPClientParameterEncoding)aEncoding
			   succ:(SUCCESSBLOCK)success
			failure:(FAILUREBLOCK)failure{
	
    AFHTTPClient *httpClient = [OLNetManager shareClient];
	
    httpClient.parameterEncoding = aEncoding;
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:aMethod path:aUrl parameters:aDict];
    [request setTimeoutInterval:NetworkTimeout];
	
//    NSMutableDictionary *headDict = [NSMutableDictionary dictionaryWithCapacity:0];

//    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
//    NSString *strVersion = [infoDict objectForKey:@"CFBundleVersion"];
//    [headDict setObject:strVersion forKey:@"clinetVersion"];

//    NSString *strHeadInfo = [headDict JSONString];
//    [request addValue:strHeadInfo forHTTPHeaderField:@"Client-Info"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        //请求成功
        /////先做一个result的判断
        NSDictionary *Dict = [operation.responseString objectFromJSONString];
        if(Dict)
			{
            BOOL isSuccess = [[Dict objectForKey:@"success"] boolValue];
            if(isSuccess)
				{
                success(Dict);
                return ;
				}
			}
        success(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		//        //请求失败
        if(error.code == -1009)
			{
            //MBTipWindow *tipWindow = [MBTipWindow GetInstance];
            //[tipWindow showNetMessage:@"当前网络有问题" type:EVENT_FAIL];
			}
        failure(nil, error);
    }];
    [operation start];
}

+ (AFHTTPClient *)shareClient{
	static AFHTTPClient *httpClient;
	if (!httpClient) {
		httpClient = [[AFHTTPClient alloc] initWithBaseURL:nil];
	}
	return httpClient;
}

@end
