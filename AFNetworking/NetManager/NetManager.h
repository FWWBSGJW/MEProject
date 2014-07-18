//
//  NetManager.h
//  JieJiong
//
//  Created by xie licai on 12-12-21.
//  Copyright (c) 2012年 xie licai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyHttpClient.h"

#define SUCCESSBLOCK      void(^)(NSDictionary* successDict)
#define FAILUREBLOCK      void(^)(NSDictionary *failDict, NSError *error)
#define PROGRESSBLOCK     void(^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)

@interface NetManager : NSObject
/******************************************************
 *  aDict   body数据 如果没有业务数据此值为nil
 *  aUrl
 *  aMethod
 *  aEncoding
 *  success
 *  failure
 */
+ (void)requestWith:(NSDictionary *)aDict
                url:(NSString *)aUrl
             method:(NSString *)aMethod
     parameEncoding:(AFHTTPClientParameterEncoding)aEncoding
               succ:(SUCCESSBLOCK)success
            failure:(FAILUREBLOCK)failure;

+ (void)uploadImg:(UIImage*)aImg
       parameters:(NSDictionary*)aParam
        uploadUrl:(NSString*)aUrl
   parameEncoding:(AFHTTPClientParameterEncoding)aEncoding
    progressBlock:(PROGRESSBLOCK)block
             succ:(SUCCESSBLOCK)success
          failure:(FAILUREBLOCK)failure;
@end
