//
//  DanmakuModel.h
//  移动教育1.0
//
//  Created by yato_kami on 14-7-15.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DanmakuView;

typedef NS_ENUM(NSInteger, DanmakuType) {
    moveDanmaku = 0,
    staticDanmaku,
};

@interface DanmakuModel : NSObject


@property (assign, nonatomic) CGFloat moveDanmukuY;
@property (assign, nonatomic) CGFloat staticDanmakuY;

@property (strong, nonatomic) NSMutableArray *moveDanmakuReUseArray;
@property (strong, nonatomic) NSMutableArray *staticDanmakuReUseArray;

/**
 *  寻找对应类型的可复用弹幕
 *
 *  @param type DanmakuType
 *
 *  @return 弹幕对象
 */
- (DanmakuView *)dequeueReusableDanmakuWithDanmakuType:(DanmakuType)type;

- (void)addNoUseDanmaku:(DanmakuView *)danmakuLabel WithDanmakuType:(DanmakuType)type;

@end
