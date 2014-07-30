//
//  CourseDirection.h
//  移动教育1.0
//
//  Created by yato_kami on 14-7-4.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>
//课程方向类
@interface CourseDirection : NSObject

@property (assign, nonatomic) NSInteger CDid; //课程方向id
@property (strong, nonatomic) NSString *CDhead; //课程方向标题
@property (strong, nonatomic) NSString *CDdescription;//课程方向简要描述
@property (assign, nonatomic) NSInteger CDpeopleNum;//课程方向学习人数
@property (assign, nonatomic) CGFloat CDtime; //课程方向总时长
@property (strong, nonatomic) NSString *CDimageUrlString;//图片url

//

@property (strong, nonatomic) NSString *CDdetail; //课程方向详细介绍
@property (assign, nonatomic) NSInteger CDcourseNum;//课程数量
@property (assign, nonatomic) NSInteger CDvideoNum; //课程方向视频数量
@property (assign, nonatomic) NSInteger CDpracticeNum;//课程方向练习数


- (void)setCourseDirectionWithDictionary:(NSDictionary *)dictionary;
@end
