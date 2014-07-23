//
//  JJDirectionManage.m
//  在线教育
//
//  Created by Johnny's on 14-7-23.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "JJDirectionManage.h"
NSArray *serverRespObj;
@implementation JJDirectionManage

- (NSArray *)analyseJson
{
    [self getData];
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    for (int i=0; i<serverRespObj.count; i++)
    {
        JJDirectionModel *model = [[JJDirectionModel alloc] init];
        NSDictionary *dict = [serverRespObj objectAtIndex:i];
        [model setDirectionModelWithDictionary:dict];
        [mArray addObject:model];
    }
    
    return mArray;
}

- (void)getData
{
    NSString * url = [@"http://121.197.10.159:8080/MobileEducation/testDriectionAction" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
        serverRespObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //            NSLog(@"server return %@",serverRespObj);
        //            keyArray = @[];
        // 切换到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
    
}



@end
