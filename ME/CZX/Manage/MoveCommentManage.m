//
//  MoveCommentManage.m
//  ME
//
//  Created by Johnny's on 14-9-10.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "MoveCommentManage.h"
NSArray *commentServerRespObj;

@implementation MoveCommentManage

- (NSMutableArray *)analyseCommentJsonForVC:(TrendDetailViewController *)paramVC withCommentUrl:(NSString *)paramUrl
{
    [self getDataForVC:paramVC withCommentUrl:paramUrl];
    
    return [self analyse];
}

- (NSMutableArray *)analyse
{
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    for (int i=0; i<commentServerRespObj.count; i++)
    {
        NSDictionary *dict = [commentServerRespObj objectAtIndex:i];
        MoveCommentModel *commentModel = [[MoveCommentModel alloc] initWithDictionary:dict];
        [mArray addObject:commentModel];
    }
    
    return mArray;
}

- (NSMutableArray *)analyseCommentJsonWithCommentUrl:(NSString *)paramUrl
{
    [self getCommentDataWithUrl:paramUrl];
    return [self analyse];
}

- (void)getCommentDataWithUrl:(NSString *)paramUrl
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
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        commentServerRespObj = [dict objectForKey:@"com"];
        //            NSLog(@"server return %@",serverRespObj);
        //            keyArray = @[];
        // 切换到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
    
}

- (void)getDataForVC:(TrendDetailViewController *)paramVC withCommentUrl:(NSString *)paramUrl
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
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            commentServerRespObj = [dict objectForKey:@"com"];
            //            NSLog(@"server return %@",serverRespObj);
            //            keyArray = @[];
            // 切换到主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                paramVC.commentArray = [self analyse];
//                if (paramVC.commentArray.count == 13)
//                {
//                    TrendModel *model = [paramVC.commentArray lastObject];
//                    paramVC.nextPage = model.nextPage;
//                    [paramVC.commentArray removeLastObject];
//                }
//                else
//                {
//                    paramVC.nextPage = @"";
//                }
                [paramVC.commentTableView reloadData];
            });
        }
    });
}

@end
