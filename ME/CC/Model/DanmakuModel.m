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
{
    NSInteger _lastArrayNum ; //弹幕内容数组控制
}
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

- (NSMutableArray *)dmChannel
{
    if (!_dmChannel) {
        _dmChannel = [NSMutableArray arrayWithCapacity:SCREEN_HEIGHT/_moveDanmukuHeight];
        for (NSInteger i=0; i < SCREEN_HEIGHT/_moveDanmukuHeight; i++) {
            [_dmChannel addObject:@1];
        }
    }
    return _dmChannel;
}

- (instancetype)initWithVideoID:(NSInteger)videoID andUserID:(NSInteger)userID
{
    self = [super init];
    self.userID = userID;
    self.videoID = videoID;

    _moveDanmukuHeight = 25.0;
    _lastArrayNum = 0;
    //初始化弹幕高度
    _staticDanmakuY = SCREEN_WIDTH;
    [self loadDanmakuArray];
    
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
    /*
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //self.danmakuArray = JSON;
        self.danmakuArray = [NSMutableArray arrayWithArray:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@,%@",error.localizedDescription,JSON);
    }];
    [op start];
     */
    NSURLResponse *response = nil;
    NSError *error = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (data != nil) {
        self.danmakuArray =[NSMutableArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]];
    } else if (data == nil && error == nil) {
        NSLog(@"空数据");
    } else {
        NSLog(@"%@",error.localizedDescription);
    }
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

#pragma mark - 选择实现实现弹幕
- (void)selectDanmukuWithCurrentTime:(NSTimeInterval)currentPlaybackTime
{
    NSLog(@"%@",self.danmakuArray);
    for (NSInteger i = _lastArrayNum; i < self.danmakuArray.count; i++) {
        if ((int)(currentPlaybackTime) == [self.danmakuArray[i][@"Dtime"] integerValue]) {
            
            
            switch ([self.danmakuArray[i][@"Dtype"] integerValue]) {
                case 0:  //动态弹幕 评论
                {
                    NSInteger dmChaennel = self.seletDanmakuChannel;
                    NSLog(@"----------------通道--------%d",dmChaennel);
                    self.moveDanmukuY = self.moveDanmukuHeight * dmChaennel;
                    DanmakuView *danmakuView = [self dequeueReusableDanmakuWithDanmakuType:moveDanmaku];
                    if (danmakuView == nil) {
                        //NSLog(@"nil");
                        danmakuView = [[DanmakuView alloc] initMoveDM];
                    }
                    [self.danmakuView addSubview:danmakuView];
                    [danmakuView setSizeWithComponent:self.danmakuArray[i][@"Dcomponent"]];
                    CGSize dmSize = danmakuView.frame.size;
                    [danmakuView setFrame:CGRectMake(SCREEN_HEIGHT, self.moveDanmukuY, danmakuView.frame.size.width, danmakuView.frame.size.height)];
                    //self.danmakuView.backgroundColor = [UIColor whiteColor];
                    //danmakuView.backgroundColor = [UIColor whiteColor];
                    //danmakuView.backgroundColor = [UIColor whiteColor];
                    //danmakuView.frame = CGRectMake(100, 100, 100, 100);
                    //设置弹幕动画
//                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                        NSLog(@"%f    %f",danmakuView.frame.origin.x,danmakuView.frame.origin.y);
//                        [self.danmakuView addSubview:danmakuView];
//                        [self danmakuChannelOpen:dmChaennel WithDMwith:dmSize.width];
//                        [self moveDM:danmakuView];
//                    }];
                    
//                    [self.danmakuView addSubview:danmakuView];
                    [self danmakuChannelOpen:dmChaennel WithDMwith:dmSize.width];
                    [self moveDM:danmakuView];
                    /*
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        [self danmakuChannelOpen:dmChaennel WithDMwith:dmSize.width];
                        [self moveDM:danmakuView];
                    });
                     */
 
                }
                    
                    break;
                case 1:   //静态弹幕
                {
                    DanmakuView *danmakuView = [self dequeueReusableDanmakuWithDanmakuType:staticDanmaku];
                    if (danmakuView == nil) {
                        danmakuView = [[DanmakuView alloc] initStaticDM];
                    }
                    [danmakuView setStaticDMSizeWithComponent:self.danmakuArray[i][@"Dcomponent"]];
                    CGSize dmSize = danmakuView.frame.size;
                    [danmakuView setFrame:CGRectMake((SCREEN_HEIGHT-dmSize.width)/2.0, _staticDanmakuY-dmSize.height, dmSize.width, dmSize.height)];
                    
                    
                    NSLog(@"%f %f",danmakuView.frame.origin.x,danmakuView.frame.origin.y);
                    _staticDanmakuY -= dmSize.height;
                    [self.danmakuView addSubview:danmakuView];
                    
                    
                    [self performSelector:@selector(hidSDM:) withObject:danmakuView afterDelay:3.0f];
                    //主线程跟新ui
                    /*
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        //self.danmakuView.backgroundColor = [UIColor whiteColor];
                        [self performSelector:@selector(hidSDM:) withObject:danmakuView afterDelay:3.0f];
                    }];
                     */
                    
                }
                default:
                    break;
            }
            
        }
        if ((int)(currentPlaybackTime) < [self.danmakuArray[i][@"Dtime"] integerValue])
            break;
    }

}

- (void)moveDM:(DanmakuView *)dmView
{
    [self performSelector:@selector(hidMDM:) withObject:dmView afterDelay:5.5f];
    [UIView animateWithDuration:5.5f animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [dmView setFrame:CGRectMake(0.0-dmView.frame.size.width, dmView.frame.origin.y, dmView.frame.size.width, dmView.frame.size.height)];
    } ];
    
}

- (void)hidSDM:(DanmakuView *)dmView
{
    dmView.alpha = 0.0;
    _staticDanmakuY += dmView.frame.size.height;
    [self addNoUseDanmaku:dmView WithDanmakuType:staticDanmaku];
    [dmView removeFromSuperview];
    
}

- (void)hidMDM:(DanmakuView *)dmView
{
    [self addNoUseDanmaku:dmView WithDanmakuType:staticDanmaku];
    [dmView removeFromSuperview];
}

#pragma mark - 选取空余位置出现弹幕
- (NSInteger)seletDanmakuChannel
{
    NSInteger i;
    for (i = 0; i < self.dmChannel.count; i++) {
        if ([self.dmChannel[i] integerValue] == 1)
            break;
    }
    i = (i<self.dmChannel.count ? i:0);
    self.dmChannel[i] = @0;
    return i;
}

- (void)danmakuChannelOpen:(NSInteger)dmChannel WithDMwith:(CGFloat)dmWith
{
    static CGFloat moveDMtime = 5.5f;
    CGFloat denyTime = (dmWith)/SCREEN_WIDTH * moveDMtime;
    [self performSelector:@selector(danmakuChannelShouldOpen:) withObject:[NSNumber numberWithInteger:dmChannel] afterDelay:denyTime];

}


- (void)danmakuChannelShouldOpen:(NSNumber *)dmChannel
{
    self.dmChannel[[dmChannel integerValue]] = @1;
}

@end
