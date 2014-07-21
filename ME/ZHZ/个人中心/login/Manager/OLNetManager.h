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
- (NSDictionary *)loginWith:(NSString *)username
	  andPassword:(NSString *)password
			 succ:(SUCCESSBLOCK)success;
@end
