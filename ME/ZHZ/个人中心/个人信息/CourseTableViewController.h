//
//  CourseTableViewController.h
//  ME
//
//  Created by qf on 14/7/22.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTableViewController : UITableViewController
@property (nonatomic,strong) NSMutableArray *courses;
@property (nonatomic,strong) NSString *link;
@property (nonatomic) BOOL deletable;
@end
