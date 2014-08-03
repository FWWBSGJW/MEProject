//
//  RankingManage.m
//  ME
//
//  Created by Johnny's on 14-8-3.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "RankingManage.h"
NSArray *rankingServerRespObj;

@implementation RankingManage
- (NSMutableArray *)analyseRankingJsonForVC:(JJFinishViewController *)paramVC withUrl:(NSString *)paramurl
{
    [self getDataForVC:paramVC withUrl:paramurl];
    
    return [self analyse];
}

- (NSMutableArray *)analyse
{
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    for (int i=0; i<rankingServerRespObj.count; i++)
    {
        NSDictionary *dict = [rankingServerRespObj objectAtIndex:i];
        RangkingModel *rankingModel = [[RangkingModel alloc] initWithDictionary:dict];
        [mArray addObject:rankingModel];
    }
    
    return mArray;
}


- (void)getDataForVC:(JJFinishViewController *)paramVC withUrl:(NSString *)paramurl
{
    NSString * url = [paramurl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
            rankingServerRespObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            //            NSLog(@"server return %@",serverRespObj);
            //            keyArray = @[];
            // 切换到主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [paramVC.activityView stopAnimating];
                [paramVC achieveScoreView];
                paramVC.scoreArray = [self analyse];
                [paramVC.scoreTableView reloadData];
            });
        }
    });
}



@end
