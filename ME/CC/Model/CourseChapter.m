//
//  CourseChapter.m
//  ME
//
//  Created by yato_kami on 14-7-22.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "CourseChapter.h"

@interface CourseChapter()

@property (strong, nonatomic) NSOperationQueue *queue;

@end

@implementation CourseChapter


- (void)loadCourseInfoWithCourseID:(NSInteger)courseID
{
    NSString *str = [kBaseURL stringByAppendingString:[NSString stringWithFormat:@"MobileEducation/courseIdAction?Cid=%d",courseID]];
    //NSLog(@"%@",str);
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.5f];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //NSLog(@"%@",data);
    
    if (data != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        self.courseInfoDic = dic;
    } else if (data == nil && error == nil) {
        NSLog(@"空数据");
    } else {
        NSLog(@"%@",error.localizedDescription);
    }
}

@end
