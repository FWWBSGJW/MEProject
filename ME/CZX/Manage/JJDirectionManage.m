//
//  JJDirectionManage.m
//  在线教育
//
//  Created by Johnny's on 14-7-23.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "JJDirectionManage.h"
#define kFileName @"directionModelArray.arch"
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

@implementation JJDirectionManage

- (NSArray *)analyseJsonForVC:(JJTestViewController *)vc
{
    [self getData:vc];
//    NSFileManager *fileManager = [[NSFileManager alloc] init];
//    NSString *imagesDir = [[NSURL applicationDocumentsDirectory] stringByAppendingPathComponent:@"CZX.ME"];
//    NSError *error = nil;
//    if ([fileManager createDirectoryAtPath:imagesDir
//               withIntermediateDirectories:YES
//                                attributes:nil
//                                     error:&error]){
//        NSLog(@"Successfully created the directory.");
//    } else {
//        NSLog(@"Failed to create the directory. Error = %@", error); }
//    [self saveDirectionModel:[self analyseJson]];
    
    return [self queryModels];
//    return [self analyseJson];
}

- (NSArray *)analyseJson
{
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

- (void)getData:(JJTestViewController *)vc
{
    NSString * url = [@"http://121.197.10.159:8080/MobileEducation/testDriectionAction" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
            serverRespObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSArray *array = [self analyseJson];
            if (array.count != [self queryModels].count) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    vc.detailArray = array;
                    [vc.testTableView reloadData];
                    [self saveDirectionModel:array];
                });
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
    NSString * dataBasePath = [[NSURL applicationDocumentsDirectory] stringByAppendingPathComponent:kFileName];
    return dataBasePath;
}

@end
