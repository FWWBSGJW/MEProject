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
@property (strong, nonatomic) NSMutableArray *courseChapterArray;//课程章节数组
@property (strong, nonatomic) NSMutableArray *courseCommentArray;//课程评论数组

@property (strong, nonatomic) NSString *nextCommentPageUrl;

- (void)loadCourseInfoWithCourseID:(NSInteger)courseID; //通过课程id载入课程信息

- (void)loadCourseAllChapterWithCourseID:(NSInteger)courseID; //通过课程id载入课程章节信息

- (NSArray *)loadCourseDetailChapterWithChapterID:(NSInteger)chapterID;//用过章id 返回此章中的具体章节

- (void)loadCourseCommentWithCourseID:(NSInteger)courseID andPage:(NSInteger)pageNum; 

- (void)loadNextPageCourseComment;

- (void)sendCourseCommentWithCourseID:(NSInteger)courseID andUserID:(NSInteger)userID andContent:(NSString *)content;

@end
