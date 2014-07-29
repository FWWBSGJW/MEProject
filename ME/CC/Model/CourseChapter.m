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

- (void)loadCourseAllChapterWithCourseID:(NSInteger)courseID
{
    NSString *str = [kBaseURL stringByAppendingString:[NSString stringWithFormat:@"MobileEducation/chapterAction?CId=%d",courseID]];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.5f];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (data != nil) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *muArray = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary *dic in array) {
            NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [muArray addObject:muDic];
        }
        self.courseChapterArray = muArray;
    } else if (data == nil && error == nil) {
        NSLog(@"空数据");
    } else {
        NSLog(@"%@",error.localizedDescription);
    }
}

- (NSArray *)loadCourseDetailChapterWithChapterID:(NSInteger)chapterID
{
    NSString *str = [kBaseURL stringByAppendingString:[NSString stringWithFormat:@"MobileEducation/videoAction?chapter=%d",chapterID]];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.5f];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSArray *array;
    if (data != nil) {
        array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    } else if (data == nil && error == nil) {
        NSLog(@"空数据");
    } else {
        NSLog(@"%@",error.localizedDescription);
    }
    return array;
}

- (void)loadCourseCommentWithCourseID:(NSInteger)courseID andPage:(NSInteger)pageNum
{
    //http://121.197.10.159:8080/MobileEducation/commentAction?page=1&CId=1
    NSString *str = [kBaseURL stringByAppendingString:[NSString stringWithFormat:@"MobileEducation/commentAction?page=%d&CId=%d",pageNum,courseID]];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.5f];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (data != nil) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        //self.courseCommentArray = array;
        if (self.courseCommentArray) {
            [self.courseCommentArray addObjectsFromArray:array];
        } else {
            self.courseCommentArray = [NSMutableArray arrayWithArray:array];
        }
        if ([self.courseCommentArray lastObject][@"nextPage"]) {
            self.nextCommentPageUrl = [self.courseCommentArray lastObject][@"nextPage"];
        } else if ([self.courseCommentArray lastObject][@"nextPage"]==nil){
            self.nextCommentPageUrl = nil;
        }
        [self.courseCommentArray removeLastObject];
        
    } else if (data == nil && error == nil) {
        NSLog(@"空数据");
    } else {
        NSLog(@"%@",error.localizedDescription);
    }
}

- (void)loadNextPageCourseComment
{
    if (self.nextCommentPageUrl) {
        NSURL *url = [NSURL URLWithString:self.nextCommentPageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.5f];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (data != nil) {
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            //self.courseCommentArray = array;
            if (self.courseCommentArray) {
                [self.courseCommentArray addObjectsFromArray:array];
            } else {
                self.courseCommentArray = [NSMutableArray arrayWithArray:array];
            }
            if ([self.courseCommentArray lastObject][@"nextPage"]) {
                self.nextCommentPageUrl = [self.courseCommentArray lastObject][@"nextPage"];
            } else {
                self.nextCommentPageUrl = nil;
            }
            [self.courseCommentArray removeLastObject];
            
        } else if (data == nil && error == nil) {
            NSLog(@"空数据");
        } else {
            NSLog(@"%@",error.localizedDescription);
        }
    }
    
}

@end
