//
//  RecommendViewController.h
//  ME
//
//  Created by yato_kami on 14-8-12.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendViewController : UITableViewController
//实例化
- (instancetype)initWithUserID:(NSInteger)userID andCourseID:(NSInteger)courseID;

@end
