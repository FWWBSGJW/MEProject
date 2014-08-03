//
//  JJTestDivideViewController.h
//  ME
//
//  Created by Johnny's on 14-7-23.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "JJBaseViewController.h"
#import "JJTestModel.h"

@interface JJTestDivideViewController : JJBaseViewController

@property(nonatomic, strong) UITableView *testTableView;
@property(nonatomic, strong) UIActivityIndicatorView *activityView;
- (id)initWithDetailUrl:(NSString *)paramUrl;
@property(nonatomic, strong) NSMutableArray *testArray;
@property(nonatomic, strong) JJTestModel *linkModel;
- (void)addTableView;
@end
