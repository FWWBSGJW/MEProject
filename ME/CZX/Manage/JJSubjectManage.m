//
//  JJSubjectManage.m
//  ME
//
//  Created by Johnny's on 14-7-24.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "JJSubjectManage.h"
#import "User.h"
//#define kFileName @"wrongSubjectModelArray.arch"
@interface NSURL (doc)
+ (NSString *)applicationDocumentsDirectory ;
@end

@implementation NSURL (doc)

+ (NSString *)applicationDocumentsDirectory
{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) [0];
}

@end


@implementation JJSubjectManage
NSArray *subjectServerRespObj;



- (NSArray *)analyseSubjectJson:(NSString *)paramUrl forSubjectVC:(JJMeasurementViewController *)paramVC
{
    [self getData:paramUrl forSubjectVC:paramVC];

    return [self analyse];
}

- (NSArray *)analyse
{
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


- (void)getData:(NSString *)paramUrl forSubjectVC:(JJMeasurementViewController *)paramVC
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
        subjectServerRespObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //            NSLog(@"server return %@",serverRespObj);
        //            keyArray = @[];
        // 切换到主线程刷新UI
        if (subjectServerRespObj.count>0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                paramVC.subjectArray = [self analyse];
                [paramVC getSubjectDetail];
                [paramVC.activityView stopAnimating];
                [paramVC.measureTableView reloadData];
                [paramVC startTimer];
            });
        }
        else
        {
            [paramVC.activityView stopAnimating];
            [paramVC noData];
        }
    }
    });
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

-(NSString *)getFilePath{
    //    NSString *string = [[NSURL applicationDocumentsDirectory] stringByAppendingPathComponent:@"CZX.Me"];
    User *user = [User sharedUser];
    NSString * dataBasePath = [[NSURL applicationDocumentsDirectory]
                               stringByAppendingPathComponent:
                               [NSString stringWithFormat:@"wrongSubjectModelArray%d.arch", user.info.userId]];
    return dataBasePath;
}


@end
