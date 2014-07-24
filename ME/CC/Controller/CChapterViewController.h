//
//  CChapterViewController.h
//  移动教育1.0
//
//  Created by yato_kami on 14-7-9.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CChapterViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

+ (instancetype)chapterVCwithCourseID:(NSInteger)courseID; //以id实例化方法


@end
