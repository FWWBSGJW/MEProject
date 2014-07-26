//
//  JJTestModelManage.m
//  ME
//
//  Created by Johnny's on 14-7-23.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "JJTestModelManage.h"
NSArray *testServerRespObj;
@implementation JJTestModelManage

- (NSArray *)analyseTestJson:(NSString *)paramUrl
{
    [self getData:paramUrl];
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    for (int i=0; i<testServerRespObj.count; i++)
    {
        JJTestModel *testModel = [[JJTestModel alloc] init];
        NSDictionary *dict = [testServerRespObj objectAtIndex:i];
        [testModel setTestModelWithDictionary:dict];
        [mArray addObject:testModel];
    }
    
    return mArray;
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
