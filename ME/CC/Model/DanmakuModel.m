//
//  DanmakuModel.m
//  移动教育1.0
//
//  Created by yato_kami on 14-7-15.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "DanmakuModel.h"
#import "AFJSONRequestOperation.h"
#define maxNum 100

@implementation DanmakuModel

#pragma mark getter and setter
- (NSMutableArray *)moveDanmakuReUseArray
{
    if (_moveDanmakuReUseArray == nil) {
        _moveDanmakuReUseArray = [NSMutableArray arrayWithCapacity:maxNum];
    }
    return _moveDanmakuReUseArray;
}

- (NSMutableArray *)staticDanmakuReUseArray
{
    if (_staticDanmakuReUseArray == nil) {
        _staticDanmakuReUseArray = [NSMutableArray arrayWithCapacity:maxNum];
    }
    return _staticDanmakuReUseArray;
}



- (instancetype)initWithVideoID:(NSInteger)videoID andUserID:(NSInteger)userID
{
    self = [super init];
    self.userID = userID;
    self.videoID = videoID;
    return self;
}

#pragma mark - 复用
- (DanmakuView *)dequeueReusableDanmakuWithDanmakuType:(DanmakuType)type
{
    switch (type) {
        case moveDanmaku:
        {
            if (self.moveDanmakuReUseArray.count) {
                return self.moveDanmakuReUseArray.lastObject;
            }else
                return nil;
        }
            break;
        case staticDanmaku:
        {
            if (self.staticDanmakuReUseArray.count) {
                UILabel *lable = self.staticDanmakuReUseArray.lastObject;
                lable.alpha = 1.0f;
                return self.staticDanmakuReUseArray.lastObject;
            } else
                return nil;
        }
            break;
        default:
            break;
    }
}

- (void)addNoUseDanmaku:(DanmakuView *)danmakuLabel WithDanmakuType:(DanmakuType)type
{
    switch (type) {
        case moveDanmaku:
        {
            [self.moveDanmakuReUseArray addObject:danmakuLabel];
        }
            break;
        case staticDanmaku:
        {
            [self.staticDanmakuReUseArray addObject:danmakuLabel];
        }
            break;
        default:
            break;
    }
}

//下载弹幕数据
- (void)loadDanmakuArray
{
    NSString *urlString = [NSString stringWithFormat:@"%@MobileEducation/C_VideoAction?Vid=%d&userId=%d",kBaseURL,self.videoID,self.userID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.danmakuArray = JSON;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@,%@",error.localizedDescription,JSON);
    }];
    [op start];
}

#pragma mark - 上传弹幕
//121.197.10.159:8080/MobileEducation/uploadVComment?cvContent=lldsdfdsd&userId=1&vid=1&cvType=true&cvTime=21
- (void)sendDanmakuWithUserID:(NSInteger)userID andVideoTime:(NSInteger)cvTime andvideoID:(NSInteger)videoID andContent:(NSString *)content andType:(NSInteger)cvType
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@MobileEducation/uploadVComment",kBaseURL]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *bodyStr = [NSString stringWithFormat:@"cvContent=%@&userId=%d&vid=%d&cvType=%s&cvTime=%d",content,userID,videoID,cvType?"true":"false",cvTime];
    NSLog(@"%@",bodyStr);
    
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:body];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

@end
