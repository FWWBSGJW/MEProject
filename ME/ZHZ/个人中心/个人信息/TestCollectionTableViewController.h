//
//  TestCollectionTableViewController.h
//  ME
//
//  Created by qf on 14/8/4.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListInfo.h"
@interface TestCollectionTableViewController : UITableViewController
@property (strong,nonatomic) NSMutableArray *testData;
@property (strong,nonatomic) ListInfo *list;
- (id)initWithStyle:(UITableViewStyle)style withData:(NSMutableArray *)data;
@end
