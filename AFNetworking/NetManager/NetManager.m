//
//  NetManager.m
//  JieJiong
//
//  Created by xie licai on 12-12-21.
//  Copyright (c) 2012年 xie licai. All rights reserved.
//

#import "NetManager.h"
#import "JSONKit.h"
//#import "FWLocationObj.h"

//#import "ResultData.h"
//#import "MBTipWindow.h"
#define NetworkTimeout  30
@implementation NetManager

+ (void)requestWith:(NSDictionary *)aDict
                url:(NSString *)aUrl
             method:(NSString *)aMethod
     parameEncoding:(AFHTTPClientParameterEncoding)aEncoding
               succ:(SUCCESSBLOCK)success
            failure:(FAILUREBLOCK)failure
{
    AFHTTPClient *httpClient = [MyHttpClient shareHttpClient];

    httpClient.parameterEncoding = aEncoding;
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:aMethod path:aUrl parameters:aDict];
    [request setTimeoutInterval:NetworkTimeout];
//    FWLocationObj *myLocation = [FWLocationObj getMyLocationInstance];

    NSMutableDictionary *headDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    [headDict setObject:[NSString stringWithFormat:@"IOS%.2f", kSystemVersion] forKey:@"clientOs"];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *strVersion = [infoDict objectForKey:@"CFBundleVersion"];
    [headDict setObject:strVersion forKey:@"clinetVersion"];
//    if(!IS_DOUBLE_ZERO(myLocation.latitude) && !IS_DOUBLE_ZERO(myLocation.longitude))
//    {
//        NSNumber *numLat = [NSNumber numberWithDouble:[FWLocationObj getMyLocationInstance].latitude];
//        NSNumber *numLong = [NSNumber numberWithDouble:[FWLocationObj getMyLocationInstance].longitude];
//        NSString *strCoor = [NSString stringWithFormat:@"%@,%@", [numLat stringValue], [numLong stringValue]];
//        [headDict setObject:strCoor forKey:@"verify_coordinates"];
//    }
//    else
//    {
//        [myLocation statUpdateLocation];
//    }
    NSString *strHeadInfo = [headDict JSONString];
    [request addValue:strHeadInfo forHTTPHeaderField:@"Client-Info"];
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
        //请求失败
//        MLOG(@"%@", error);
        if(error.code == -1009)
        {
            //MBTipWindow *tipWindow = [MBTipWindow GetInstance];
            //[tipWindow showNetMessage:@"当前网络有问题" type:EVENT_FAIL];
        }
        failure(nil, error);
    }];
    [operation start];
//    MLOG(@"aUrl=%@ aDict=%@", aUrl, aDict);
}

+ (void)uploadImg:(UIImage*)aImg
       parameters:(NSDictionary*)aParam
        uploadUrl:(NSString*)aUrl
   parameEncoding:(AFHTTPClientParameterEncoding)aEncoding
    progressBlock:(PROGRESSBLOCK)block
             succ:(SUCCESSBLOCK)success
          failure:(FAILUREBLOCK)failure
{
    
    AFHTTPClient *httpClient = [MyHttpClient shareHttpClient];
    httpClient.parameterEncoding = aEncoding;
    NSData *imageData = UIImageJPEGRepresentation(aImg, 1);
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:aUrl parameters:aParam constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        [formData appendPartWithFileData:imageData name:@"cardImage" fileName:@"cardImage.jpg" mimeType:@"image/jpeg"];
        
    }];
    [request setTimeoutInterval:NetworkTimeout];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *Dict = [operation.responseString objectFromJSONString];
        NSURLRequest *temRequest = operation.request;
        NSString *strRequestID = [temRequest valueForHTTPHeaderField:@"uploadImgRequestID"];
        NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithCapacity:0];
        [mutDict setObject:Dict forKey:@"successDict"];
        [mutDict setObject:strRequestID forKey:@"requestID"];
        success(mutDict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *resultDictionary = [operation.responseString objectFromJSONString];
        NSURLRequest *temRequest = operation.request;
        NSString *strRequestID = [temRequest valueForHTTPHeaderField:@"uploadImgRequestID"];
        NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithCapacity:0];
        [mutDict setObject:resultDictionary forKey:@"failDict"];
        [mutDict setObject:strRequestID forKey:@"requestID"];
        failure(mutDict, error);
    }];
    [operation start];
}
@end
