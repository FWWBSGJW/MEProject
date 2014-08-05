//
//  JJTestModelManage.m
//  ME
//
//  Created by Johnny's on 14-7-23.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "JJTestModelManage.h"
NSDictionary *testServerRespObj;
@implementation JJTestModelManage

- (NSArray *)analyseTestJson:(NSString *)paramUrl forVC:(JJTestDivideViewController *)paramVC
{
    [self getData:paramUrl forVC:paramVC];
    return [self analyse];
}

- (NSArray *)analyseTestJson:(NSString *)paramUrl
{
    [self getData:paramUrl];

    return [self analyse];
}

- (NSArray *)analyse
{
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    NSArray *array1 = [testServerRespObj objectForKey:@"tcourse"];
    for (int i=0; i<array1.count; i++)
    {
        JJTestModel *testModel = [[JJTestModel alloc] init];
        NSDictionary *dict = [array1 objectAtIndex:i];
        [testModel setTestModelWithDictionary:dict];
        [mArray addObject:testModel];
    }
    NSDictionary *dict1 = [testServerRespObj objectForKey:@"tlink"];
    JJTestModel *testmodel = [[JJTestModel alloc] init];
    [testmodel setTestModelWithDictionary:dict1];
    [mArray addObject:testmodel];
    
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


- (void)getData:(NSString *)paramUrl forVC:(JJTestDivideViewController *)paramVC
{
    NSString * url = [paramUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
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
            [paramVC addTableView];
            paramVC.testArray = (NSMutableArray *)[self analyse];
            if (paramVC.testArray.count == 7)
            {
                paramVC.linkModel = [paramVC.testArray lastObject];
                [paramVC.testArray removeLastObject];
            }
            else
            {
                paramVC.linkModel = nil;
            }
            [paramVC.testTableView reloadData];
            [paramVC.activityView stopAnimating];
        });
    }
    });
}
@end
