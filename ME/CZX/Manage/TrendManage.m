//
//  TrendManage.m
//  ME
//
//  Created by Johnny's on 14-9-5.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "TrendManage.h"
#import "TrendModel.h"
#import "User.h"
#define kFileName @"TrendModelArray.arch"

NSDictionary *serverDict;
NSArray *serverRespObj;

@interface NSURL (doc)
+ (NSString *)applicationDocumentsDirectory ;
@end

@implementation NSURL (doc)

+ (NSString *)applicationDocumentsDirectory
{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) [0];
}

@end

@implementation TrendManage

- (NSArray *)analyseJsonForVC:(TrendsViewController *)vc
{
    return [self queryModels];
}

- (NSArray *)analyseJson
{
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    for (int i=0; i<serverRespObj.count; i++)
    {
        NSDictionary *dict = [serverRespObj objectAtIndex:i];
        TrendModel *model = [[TrendModel alloc] initWithDictionary:dict];
        [mArray addObject:model];
    }
    return mArray;
}

- (void)getData:(TrendsViewController *)vc
{
    NSString *temUrl = [NSString stringWithFormat:@"http://121.197.10.159:8080/MobileEducation/listMove?userId=%d&score=1", 1];//[User sharedUser].info.userId];
    NSString * url = [temUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
            serverDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            serverRespObj = [serverDict objectForKey:@"mod"];
            NSArray *array = [self analyseJson];
//            if ((array.count != [self queryModels].count || [self queryModels].count==0) && array.count!=0)
//            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    vc.trendsArray = (NSMutableArray *)array;
                    [vc.trendsTableView reloadData];
                    [vc.activityView stopAnimating];
                    if (vc.trendsArray.count == 10)
                    {
                        vc.page = 2;
                    }
                    [self saveDirectionModel:array];
                });
//            }
        }
    });
}

- (NSArray *)getUrlTrends:(NSString *)paramUrl
{
    NSArray *nextArray = [NSArray new];
    NSString * url = [paramUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURLResponse * resp;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] returningResponse:&resp error:&error];
        if (error)
        {
            printf("%s \n",[[error localizedDescription] UTF8String]);
            return [[NSArray alloc] init];
        }
        
        if ([data length] > 0)
        {
            serverDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            serverRespObj = [serverDict objectForKey:@"mod"];
            nextArray = [self analyseJson];
            //            if ((array.count != [self queryModels].count || [self queryModels].count==0) && array.count!=0)
            //            {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                vc.trendsArray = array;
//                [vc.trendsTableView reloadData];
//                [vc.activityView stopAnimating];
//                [self saveDirectionModel:array];
//            });
            //            }
        }
//    });

    if (nextArray.count>0)
    {
        return nextArray;
    }
    else
    {
        return [[NSArray alloc] init];
    }
}

- (NSArray *)queryModels
{
    NSArray * array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getFilePath]];
    return array;
}

- (void)saveDirectionModel:(NSArray *)paramArray
{
    [NSKeyedArchiver archiveRootObject:paramArray toFile:[self getFilePath]];
}

-(NSString *)getFilePath
{
    NSString * dataBasePath = [[NSURL applicationDocumentsDirectory] stringByAppendingPathComponent:kFileName];
    return dataBasePath;
}

@end
