//
//  CourseChapter.m
//  ME
//
//  Created by yato_kami on 14-7-22.
//  Copyright (c) 2014年 yatokami. All rights reserved.
// ---------

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
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.5f];
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
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.5f];
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

- (void)sendCourseCommentWithCourseID:(NSInteger)courseID andUserID:(NSInteger)userID andContent:(NSString *)content
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@MobileEducation/uploadCComment",kBaseURL]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];

    NSString *bodyStr = [NSString stringWithFormat:@"CId=%d&userid=%d&ccContent=%@",courseID,userID,content];
    
    NSLog(@"%@",bodyStr);
    
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:body];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
}

//121.197.10.159:8080/MobileEducation/collectionAction?userId=1&CId=1
- (NSInteger)privateWithCourseID:(NSInteger)courseID andUserID:(NSInteger)userID
{
    NSString *str = [kBaseURL stringByAppendingString:[NSString stringWithFormat:@"MobileEducation/collectionAction?userId=%d&CId=%d",userID,courseID]];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.5f];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
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
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.5f];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
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
    } else if (data == nil && error == nil) {
        NSLog(@"空数据");
    } else {
        NSLog(@"%@",error.localizedDescription);
    }
}

- (NSMutableArray *)loadCourseDetailNoteWithUrl:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
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
    return [NSMutableArray arrayWithArray:array];
}


- (void)sendCourseNoteWithCourseID:(NSInteger)courseID andUserID:(NSInteger)userID andContent:(NSString *)content
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@MobileEducation/uploadCNote",kBaseURL]];
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:url];
    //[aClient setDefaultHeader:@"Accept" value:@"text/json"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:userID],@"userId",[NSNumber numberWithInteger:courseID],@"cid",content,@"cnContext", nil];
    [httpClient postPath:nil parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}

#pragma mark - 网络代理方法
#pragma mark 1. 接收到服务器的响应，服务器要传数据，客户端做接收准备
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"response --> %@", response);
}

#pragma mark 2. 接收服务器传输的数据，可能会多次执行
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 对每次传输的数据进行拼接，需要中转数据（属性）
    [self.myData appendData:data];
    NSLog(@"%@",self.myData);
}

#pragma mark 4. 服务器请求失败，原因很多（网络环境等等）
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"网络请求错误：%@", error.localizedDescription);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%@",self.myData);
}

#pragma mark 5. 向服务器发送数据，此方法仅适用于POST，尤其上传文件ß
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    NSLog(@"发送数据给服务器");
}
@end
