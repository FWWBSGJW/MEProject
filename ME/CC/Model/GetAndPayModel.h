//
//  GetAndPayModel.h
//  ME
//
//  Created by yato_kami on 14-8-11.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//  处理积分以及支付

#import <Foundation/Foundation.h>

@interface GetAndPayModel : NSObject

@property (strong, nonatomic) NSMutableArray *userCoinArray;

- (NSInteger)getCoinForNoteWithUserID:(NSInteger)userID; //笔记

- (NSInteger)getCoinForCommentWithUserID:(NSInteger)userID; //评论

- (void)getCoinForVideoWithUserID:(NSInteger)userID; //观看视频

- (void)getCoinForDanmakuWithUserID:(NSInteger)userID WithSendedNum:(NSInteger)sendNum;//发弹幕

- (void)getCoinForShareWithUserID:(NSInteger)userID; //分享

//或得积分，异步请求
- (void)getCoinWithCount:(NSInteger)count andUserID:(NSInteger)userID;


@end
