//
//  DanmakuModel.h
//  移动教育1.0
//
//  Created by yato_kami on 14-7-15.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DanmakuView.h"
@class DanmakuView;

typedef NS_ENUM(NSInteger, DanmakuType) {
    moveDanmaku = 0,
    staticDanmaku,
};

@interface DanmakuModel : NSObject


@property (strong, nonatomic) NSMutableArray *danmakuArray;
@property (strong, nonatomic) NSMutableArray *moveDanmakuReUseArray;
@property (strong, nonatomic) NSMutableArray *staticDanmakuReUseArray;

@property (assign, nonatomic) CGFloat moveDanmukuHeight;
@property (assign, nonatomic) CGFloat staticDanmakuY;
@property (assign, nonatomic) CGFloat moveDanmukuY;

@property (assign, nonatomic) NSInteger userID;
@property (assign, nonatomic) NSInteger videoID;

@property (strong, nonatomic) NSMutableArray *dmChannel; //弹幕通道,1可用 0不可用
@property (weak, nonatomic) UIView *danmakuView;
//寻找可复用弹幕
- (DanmakuView *)dequeueReusableDanmakuWithDanmakuType:(DanmakuType)type;
//添加复用弹幕
- (void)addNoUseDanmaku:(DanmakuView *)danmakuLabel WithDanmakuType:(DanmakuType)type;
//弹幕引擎实例化
- (instancetype)initWithVideoID:(NSInteger)videoID andUserID:(NSInteger)userID;
//加载弹幕数组
- (void)loadDanmakuArray;
//选取弹幕通道
- (NSInteger)seletDanmakuChannel;
//开启弹幕通道
- (void)danmakuChannelOpen:(NSInteger)dmChannel WithDMwith:(CGFloat)dmWith;
//选择展现弹幕
- (void)selectDanmukuWithCurrentTime:(NSTimeInterval)currentPlaybackTime;
//发送弹幕
- (void)sendDanmakuWithUserID:(NSInteger)userID andVideoTime:(NSInteger)cvTime andvideoID:(NSInteger)videoID andContent:(NSString *)content andType:(NSInteger)cvType;
@end
