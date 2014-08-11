//
//  CDownloadModel.m
//  ME
//
//  Created by yato_kami on 14-8-10.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "CDownloadModel.h"
#import "AFNetworking.h"
#import "SynthesizeSingleton.h"

@implementation CDownloadModel


SYNTHESIZE_SINGLETON_FOR_CLASS(CDownloadModel);
- (id)init{
	if (self = [super init]) {
        NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [doc stringByAppendingPathComponent:@"DownloadData.plist"];
        _downloadArray = [NSMutableArray arrayWithContentsOfFile:path];
        if (!_downloadArray) {
            _downloadArray = [NSMutableArray array];
            [_downloadArray addObject:[NSMutableArray array]];
            [_downloadArray addObject:[NSMutableArray array]];
        }
        
	}
	return self;
}

- (NSMutableDictionary *)dOperationDic
{
    if (!_dOperationDic) {
        _dOperationDic = [NSMutableDictionary dictionary];
    }
    return _dOperationDic;
}

- (void)downLoadVideoWithUrlString:(NSString *)urlString andName:(NSString *)name andCNum:(NSString *)num andVideoID:(NSString *)videoID
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:num forKey:@"dcNum"];
    [dic setObject:name forKey:@"dcName"];
    [dic setObject:urlString forKey:@"dcUrl"];
    [dic setObject:@"0" forKey:@"dcSize"];
    [dic setObject:@"0" forKey:@"dcNow"];
    [dic setObject:@"0" forKey:@"dcSpeed"];
    [dic setObject:videoID forKey:@"videoID"];
    [dic setObject:@"0" forKey:@"dcLastSize"];
    [dic setObject:@1 forKey:@"dcState"];
    
    [self.downloadArray[0] addObject:dic];

    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [self.dOperationDic setObject:op forKey:videoID];
    
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *downloadPath = [docs[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",videoID]];
    [op setOutputStream:[NSOutputStream outputStreamToFileAtPath:downloadPath append:NO]];
    
    [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        dic[@"dcSize"] = [NSString stringWithFormat:@"%.3f",totalBytesExpectedToRead/(1024.0f*1024.0f)];
        dic[@"dcNow"] = [NSString stringWithFormat:@"%0.3f",totalBytesRead/(1024*1024.0f)];
        //float percent = (float)totalBytesRead / totalBytesExpectedToRead;
        //NSLog(@"%f",percent);
        /*
        NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [doc stringByAppendingString:@"DownloadData.plist"];
        [self.downloadArray writeToFile:path atomically:YES];
         */
        
    }];
    
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"下载完成");
        [self.downloadArray[0] removeObject:dic];
        [dic removeObjectForKey:@"dcNow"];
        [dic removeObjectForKey:@"dcSpeed"];
        [dic setObject:[self stringOfDate] forKey:@"dcDate"];
        [dic removeObjectForKey:@"dcLastSize"];
        [dic removeObjectForKey:@"dcState"];
        dic[@"dcUrl"] = downloadPath;
        [self.downloadArray[1] addObject:dic];
        
        [self.myDelegate upDateUI];
        NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [doc stringByAppendingPathComponent:@"DownloadData.plist"];
        [self.downloadArray writeToFile:path atomically:YES];
        [self.dOperationDic removeObjectForKey:videoID];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
        [self.downloadArray removeObject:dic];
        [self.myDelegate upDateUI];
        [self.dOperationDic removeObjectForKey:videoID];
        
    }];
    
    [op start];
}

- (NSString *)stringOfDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter stringFromDate:date];
}

- (void)pauseWithVideoID:(NSString *)videoID
{
    AFHTTPRequestOperation *op = self.dOperationDic[videoID];
    if (op) {
        [op pause];
    }
}

- (void)continueWithVideoID:(NSString *)videoID
{
    AFHTTPRequestOperation *op = self.dOperationDic[videoID];
    if (op) {
        [op start];
    }
}

- (void)deleteWithVideoID:(NSString *)videoID
{
    AFHTTPRequestOperation *op = self.dOperationDic[videoID];
    if (op) {
        [op pause];
    }
    [self.dOperationDic removeObjectForKey:videoID];
}

@end
