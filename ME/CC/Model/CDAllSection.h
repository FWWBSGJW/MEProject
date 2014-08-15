//
//  CDAllSection.h
//  ME
//
//  Created by yato_kami on 14-7-21.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDSection.h"

@protocol cdAllSectionDelegate <NSObject>
- (void)upDateUI;
@end

@interface CDAllSection : NSObject
@property (weak, nonatomic) id<cdAllSectionDelegate> delegate;
//课程方向id
@property (assign, nonatomic) NSInteger cdID;
//课程方向阶段类数组
@property (strong, nonatomic) NSMutableArray *cdAllSectionArray;
//加载数据
- (void)loadDataWithCDid:(NSInteger)cdID;

@end
