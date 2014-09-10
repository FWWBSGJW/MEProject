//
//  CourseChapter.m
//  ME
//
//  Created by yato_kami on 14-7-22.
//  Copyright (c) 2014年 yatokami. All rights reserved.
// ---------sync

#import "CourseChapter.h"

@interface CourseChapter() <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSOperationQueue *queue;

@property (strong, nonatomic) NSMutableData *myData;
@end

@implementation CourseChapter


- (void)loadCourseInfoWithCourseID:(NSInteger)courseID
{
    NSString *str = [kBaseURL stringByAppendingString:[NSString stringWithFormat:@"MobileEducation/courseIdAction?Cid=%d",courseID]];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (data != nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            self.courseInfoDic = dic;
            [self.delegate updateUI];
        } else if (data == nil && connectionError == nil) {
            NSLog(@"空数据");
        } else {
            NSLog(@"%@",connectionError.localizedDescription);
        }

    }];
    
}

- (void)loadCourseAllChapterWithCourseID:(NSInteger)courseID
{
    NSString *str = [kBaseURL stringByAppendingString:[NSString stringWithFormat:@"MobileEducation/chapterAction?CId=%d",courseID]];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:4.0f];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSError *connectionError;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&connectionError];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (data != nil) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *muArray = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary *dic in array) {
            NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [muArray addObject:muDic];
        }
        self.courseChapterArray = muArray;
    } else if (data == nil && connectionError == nil) {
        NSLog(@"空数据");
    } else {
        NSLog(@"%@",connectionError.localizedDescription);
    }
    /*
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (data != nil) {
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSMutableArray *muArray = [NSMutableArray arrayWithCapacity:array.count];
            for (NSDictionary *dic in array) {
                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [muArray addObject:muDic];
            }
            self.courseChapterArray = muArray;
            [self.delegate updateUI];
        } else if (data == nil && connectionError == nil) {
            NSLog(@"空数据");
        } else {
            NSLog(@"%@",connectionError.localizedDescription);
        }
    }];
     */
}

- (NSArray *)loadCourseDetailChapterWithChapterID:(NSInteger)chapterID
{
    NSString *str = [kBaseURL stringByAppendingString:[NSString stringWithFormat:@"MobileEducation/videoAction?chapter=%d",chapterID]];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    NSURLResponse *response = nil;
    NSError *error = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
            [self.delegate updateUI];
        } else if (data == nil && connectionError == nil) {
            NSLog(@"空数据");
        } else {
            NSLog(@"%@",connectionError.localizedDescription);
        }
    }];
}

- (void)loadNextPageCourseComment
{
    if (self.nextCommentPageUrl) {
        NSURL *url = [NSURL URLWithString:self.nextCommentPageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
        NSURLResponse *response = nil;
        NSError *error = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (data != nil) {
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
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

- (void)sendCourseCommentWithCourseID:(NSInteger)courseID andUserID:(NSInteger)userID andContent:(NSString *)content
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@MobileEducation/uploadCComment",kBaseURL]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];

    NSString *bodyStr = [NSString stringWithFormat:@"CId=%d&userid=%d&ccContent=%@",courseID,userID,content];
    
    //NSLog(@"%@",bodyStr);
    
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:body];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            //NSLog(@"评论结果返回dic：%@",dic);
        }
        
    }];
    
}

//121.197.10.159:8080/MobileEducation/collectionAction?userId=1&CId=1
- (NSInteger)privateWithCourseID:(NSInteger)courseID andUserID:(NSInteger)userID
{
    NSString *str = [kBaseURL stringByAppendingString:[NSString stringWithFormat:@"MobileEducation/collectionAction?userId=%d&CId=%d",userID,courseID]];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    NSURLResponse *response = nil;
    NSError *error = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (data != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        return [dic[@"success"] integerValue];
        
    } else if (data == nil && error == nil) {
        NSLog(@"空数据");
        return 0;
    } else {
        NSLog(@"%@",error.localizedDescription);
        return 0;
    }
}

- (void)loadCourseNoteArrayWithCourseID:(NSInteger)courseID andUserID:(NSInteger)userID
{
    NSString *str = [kBaseURL stringByAppendingString:[NSString stringWithFormat:@"MobileEducation/chapterNote?cid=%d&userId=%d",courseID,userID]];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (data != nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSMutableDictionary *normalDic = [NSMutableDictionary dictionaryWithDictionary:dic[@"normalNote"]];
            NSMutableArray *array = dic[@"videoNote"];
            NSMutableArray *noteArray = [NSMutableArray arrayWithCapacity:1+array.count];
            [noteArray addObject:normalDic];
            for (NSInteger i = 0; i < array.count; i++) {
                [noteArray addObject:[NSMutableDictionary dictionaryWithDictionary:array[i]]];
            }
            self.couserNoteArray = noteArray;
            [self.delegate updateUI];
        } else if (data == nil && connectionError == nil) {
            NSLog(@"空数据");
        } else {
            NSLog(@"%@",connectionError.localizedDescription);
        }
    }];
    
}

- (NSMutableArray *)loadCourseDetailNoteWithUrl:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    NSURLResponse *response = nil;
    NSError *error = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSArray *array;
    if (data != nil) {
        array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    } else if (data == nil && error == nil) {
        NSLog(@"空数据");
    } else {
        NSLog(@"%@",error.localizedDescription);
    }
    return [NSMutableArray arrayWithArray:array];
}


- (void)sendCourseNoteWithCourseID:(NSInteger)courseID andUserID:(NSInteger)userID andContent:(NSString *)content
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@MobileEducation/uploadCNote",kBaseURL]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *bodyStr = [NSString stringWithFormat:@"userId=%D&cid=%d&cnContext=%@",userID,courseID,content];
    
    //NSLog(@"%@",bodyStr);
    
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:body];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            //NSLog(@"笔记结果返回dic：%@",dic);
        }
        
    }];
    
}
//http://121.197.10.159:8080/MobileEducation/payCourse?Cid=5
- (NSInteger)buyCourseUseCoinWithCourseID:(NSInteger)courseID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@MobileEducation/payCourse?Cid=%d",kBaseURL,courseID]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    NSURLResponse *response = nil;
    NSError *error = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *dic;
    if (data != nil) {
        dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    } else if (data == nil && error == nil) {
        NSLog(@"空数据");
    } else {
        NSLog(@"%@",error.localizedDescription);
    }
    return [dic[@"success"] integerValue];
}
@end
