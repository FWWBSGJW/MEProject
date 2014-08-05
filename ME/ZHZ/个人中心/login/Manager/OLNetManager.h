//
//  OLNetManager.h
//  Online_learning
//
//  Created by qf on 14/7/9.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#define SUCCESSBLOCK      void(^)(NSDictionary* successDict)
#define FAILUREBLOCK      void(^)(NSDictionary *failDict, NSError *error)
@interface OLNetManager : NSObject <NSURLConnectionDataDelegate>
+ (NSDictionary *)loginWith:(NSString *)username
	  andPassword:(NSString *)password;
+ (NSDictionary *)userDataWithId:(NSString *)userId;
+ (BOOL)deleteCollectionTestWithUserId:(NSString *)userId andTestId:(NSString *)testId;
+ (NSInteger)privateWithCourseID:(NSInteger)courseID andUserID:(NSString *)userID;
@end
