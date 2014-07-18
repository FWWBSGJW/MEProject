//
//  CourseDirection.m
//  移动教育1.0
//
//  Created by yato_kami on 14-7-4.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "CourseDirection.h"

@implementation CourseDirection
- (void)setCourseDirectionWithDictionary:(NSDictionary *)dictionary
{
    _CDid = [[dictionary objectForKey:@"CDid"] integerValue];
    _CDhead = [dictionary objectForKey:@"CDhead"];
    _CDdetail = [dictionary objectForKey:@"CDdetail"];
    _CDpeopleNum = [[dictionary objectForKey:@"CDpeopleNum"] integerValue];
    _CDtime = [[dictionary objectForKey:@"CDtime"] floatValue];
    _CDimageUrlString =  [kBaseURL stringByAppendingPathComponent:[dictionary objectForKey:@"CDimageUrl"]];
    _CDdescription = [dictionary objectForKey:@"CDdescription"];
    _CDcourseNum = [[dictionary objectForKey:@"CDcourseNum"] integerValue];
    _CDvideoNum = [[dictionary objectForKey:@"CDvideoNum"] integerValue];
    _CDpracticeNum = [[dictionary objectForKey:@"CDpracticeNum"] integerValue];
    
    
}

- (NSString *)description
{
    //NSString *str = [NSString stringWithFormat:@"%@\n",self];
    NSString *str2 = [NSString stringWithFormat:@"<CourseDirection : %p , CDid:%d\nCDhead:%@\nCDdetail:%@\nCDpeopleNum:%d\nCDtime:%f\nCDimageUrlString:%@\nCDcourseNum:%d\nCDvideoNum:%d\nCDpracticeNum:%d\nCDdescription%@ >",self,_CDid,_CDhead,_CDdetail,_CDpeopleNum,_CDtime,_CDimageUrlString,_CDcourseNum,_CDvideoNum,_CDpracticeNum,_CDdescription];
    
    return str2;
}

@end
