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

//或得积分，异步请求
- (void)getCoinWithCount:(NSInteger)count andUserID:(NSInteger)userID;

@end
