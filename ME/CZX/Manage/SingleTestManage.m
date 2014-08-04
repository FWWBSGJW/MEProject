//
//  SingleTestManage.m
//  ME
//
//  Created by Johnny's on 14-8-4.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "SingleTestManage.h"
NSDictionary *testServerRespObj;
@implementation SingleTestManage

- (JJTestModel *)analyseTestJson:(NSString *)paramUrl{
    [self getData:paramUrl];
    JJTestModel *model = [[JJTestModel alloc] init];
    [model setTestModelWithDictionary:testServerRespObj];
    return model;
}


- (void)getData:(NSString *)paramUrl
{
    NSString * url = [paramUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse * resp;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] returningResponse:&resp error:&error];
    if (error)
    {
        printf("%s \n",[[error localizedDescription] UTF8String]);
        return ;
    }
    
    if ([data length] > 0)
    {
        testServerRespObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //            NSLog(@"server return %@",serverRespObj);
        //            keyArray = @[];
        // 切换到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
}

@end
