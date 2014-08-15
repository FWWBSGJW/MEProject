//
//  CouseAllDirection.h
//  移动教育1.0
//
//  Created by yato_kami on 14-7-17.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseDirection.h"

@protocol CourseDirectionDelegate <NSObject>
- (void)upDateUI;
@end

@interface CouseAllDirection : NSObject
//存储所有课程方向数据
@property (strong, nonatomic) NSMutableArray *allCourseDirectionArray;
@property (weak, nonatomic) id<CourseDirectionDelegate> delegate;

- (void)loadData;

@end
