//
//  ResultManage.m
//  ME
//
//  Created by Johnny's on 14-9-11.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "ResultManage.h"
#import "ResultBase.h"

NSArray *testDirectionServerRespObj;
@implementation ResultManage


- (NSArray *)analyseJson:(NSString *)paramUrl
{
    [self getDataUrl:paramUrl];
    
    return [self analyse];
}

- (NSMutableArray *)analyse
{
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    for (int i=0; i<testDirectionServerRespObj.count; i++)
    {
        NSDictionary *dict = [testDirectionServerRespObj objectAtIndex:i];
        ResultBase *model = [[ResultBase alloc] initWithDictionary:dict];
        [mArray addObject:model];
    }
    
    return mArray;
}


- (void)getDataUrl:(NSString *)paramurl
{
    NSString *url = paramurl;
//    NSString * url = [paramurl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
        testDirectionServerRespObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //            NSLog(@"server return %@",serverRespObj);
        //            keyArray = @[];
        // 切换到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }
}
@end
