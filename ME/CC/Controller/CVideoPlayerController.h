//
//  CVieoPlayerontroller.h
//  移动教育1.0
//
//  Created by yato_kami on 14-7-10.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface CVideoPlayerController : MPMoviePlayerViewController <UIAlertViewDelegate, UIGestureRecognizerDelegate,UIAlertViewDelegate>

//通过id构建视频
- (void)playVideoWithVideoID : (NSInteger)videoID andVideoTitle:(NSString *)videoTitle andVideoUrlString:(NSString *)urlString;

//通过id以及 视频开始时间 构建弹幕
- (void)playVideoWithVideoID:(NSInteger)videoID andStartTime:(NSTimeInterval)time andVideoUrlString:(NSString *)urlString andVideoTitle:(NSString *)title;

@end
