//
//  CDetailCourseViewController.h
//  移动教育1.0
//
//  Created by yato_kami on 14-7-5.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseDirection.h"

@interface CDetailCourseViewController : UITableViewController

@property (strong, nonatomic) CourseDirection *courseDirection; //课程方向类

+ (instancetype) detailCourseVCwithCourseDirection:(CourseDirection *)courseDirection;

@end
