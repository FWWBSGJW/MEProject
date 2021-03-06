//
//  CouseAllDirection.m
//  移动教育1.0
//
//  Created by yato_kami on 14-7-17.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "CouseAllDirection.h"

@implementation CouseAllDirection
//http://121.197.10.159:8080/MobileEducation/listCollection?userId=1
- (void)loadData
{
    //NSLog(@"加载课程方向简述数据");
    NSString *str = [kBaseURL stringByAppendingString:@"MobileEducation/directionAction"];
    
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data != nil) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self handleJSONData:data];
            [self.delegate upDateUI];
        } else if (data == nil && connectionError == nil) {
            NSLog(@"空数据");
        } else {
            NSLog(@"%@",connectionError.localizedDescription);
        }
    }];
    /*
    if (data != nil) {
        [self handleJSONData:data];
    } else if (data == nil && error == nil) {
        NSLog(@"空数据");
    } else {
        NSLog(@"%@",error.localizedDescription);
    }
  */
}


- (void)handleJSONData:(NSData *)datda
{
    //反序列化
    NSArray *array = [NSJSONSerialization JSONObjectWithData:datda options:NSJSONReadingAllowFragments error:nil];
//    
//    //保存至沙箱，持久化
//    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [docs[0] stringByAppendingPathComponent:@"CourseDirectionData.plist"];
//    [array writeToFile:path atomically:YES];
    
    NSMutableArray *allCDArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        CourseDirection *cd = [[CourseDirection alloc] init];
        [cd setCourseDirectionWithDictionary:dic];
        [allCDArray addObject:cd];
        //NSLog(@"%@",cd);
    }
    self.allCourseDirectionArray = allCDArray;
}

@end
