//
//  GetAndPayModel.m
//  ME
//
//  Created by yato_kami on 14-8-11.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//  

#import "GetAndPayModel.h"

@implementation GetAndPayModel
//http://121.197.10.159:8080/MobileEducation/uploadPoints?points=1&userId=1
- (void)getCoinWithCount:(NSInteger)count andUserID:(NSInteger)userID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@MobileEducation/uploadPoints?points=%d&userId=%d",kBaseURL,count,userID]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"获得积分");
    }];
    
}

@end
