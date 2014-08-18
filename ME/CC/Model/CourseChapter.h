//
//  CourseChapter.h
//  ME
//
//  Created by yato_kami on 14-7-22.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CourseChapterDelegate <NSObject>

- (void)updateUI;

@end

@interface CourseChapter : NSObject

@property (weak,nonatomic) id<CourseChapterDelegate> delegate;
@property (strong, nonatomic) NSDictionary *courseInfoDic;//课程信息字典
@property (strong, nonatomic) NSMutableArray *courseChapterArray;//课程章节数组
@property (strong, nonatomic) NSMutableArray *courseCommentArray;//课程评论数组
@property (strong, nonatomic) NSMutableArray *couserNoteArray;//课程笔记数组
@property (strong, nonatomic) NSString *nextCommentPageUrl;

- (void)loadCourseInfoWithCourseID:(NSInteger)courseID; //通过课程id载入课程信息

- (void)loadCourseAllChapterWithCourseID:(NSInteger)courseID; //通过课程id载入课程章节信息

- (NSArray *)loadCourseDetailChapterWithChapterID:(NSInteger)chapterID;//用过章id 返回此章中的具体章节

- (void)loadCourseCommentWithCourseID:(NSInteger)courseID andPage:(NSInteger)pageNum; //载入评论

- (void)loadNextPageCourseComment; //评论下一页
//发送评论
- (void)sendCourseCommentWithCourseID:(NSInteger)courseID andUserID:(NSInteger)userID andContent:(NSString *)content;
//发送笔记
- (void)sendCourseNoteWithCourseID:(NSInteger)courseID andUserID:(NSInteger)userID andContent:(NSString *)content;
//收藏
- (NSInteger)privateWithCourseID:(NSInteger)courseID andUserID:(NSInteger)userID;
//笔记
- (void)loadCourseNoteArrayWithCourseID:(NSInteger)courseID andUserID:(NSInteger)userID;
- (NSMutableArray *)loadCourseDetailNoteWithUrl:(NSString *)urlStr;
- (NSInteger)buyCourseUseCoinWithCourseID:(NSInteger)courseID;

@end
