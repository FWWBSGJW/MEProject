//
//  CourseChapter.h
//  ME
//
//  Created by yato_kami on 14-7-22.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface CourseChapter : NSObject

@property (strong, nonatomic) NSDictionary *courseInfoDic;//课程信息字典

- (void)loadCourseInfoWithCourseID:(NSInteger)courseID; //通过课程id载入课程信息

@end
