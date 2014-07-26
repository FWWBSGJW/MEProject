//
//  JJSubjectManage.m
//  ME
//
//  Created by Johnny's on 14-7-24.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "JJSubjectManage.h"

@implementation JJSubjectManage
NSArray *subjectServerRespObj;
- (NSArray *)analyseSubjectJson:(NSString *)paramUrl
{
    [self getData:paramUrl];
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    for (int i=0; i<subjectServerRespObj.count; i++)
    {
        JJSubjectModel *subjectModel = [[JJSubjectModel alloc] init];
        NSDictionary *dict = [subjectServerRespObj objectAtIndex:i];
        [subjectModel setSubjectModelWithDictionary:dict];
        [mArray addObject:subjectModel];
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
        subjectServerRespObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //            NSLog(@"server return %@",serverRespObj);
        //            keyArray = @[];
        // 切换到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
}
@end
