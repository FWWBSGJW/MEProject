//
//  JJTestViewController.h
//  TestVC
//
//  Created by Johnny's on 14-7-4.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "JJBaseViewController.h"
#import "XLCycleScrollView.h"

@interface JJTestViewController : JJBaseViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, XLCycleScrollViewDatasource, XLCycleScrollViewDelegate>

@property(nonatomic, strong) UITableView *testTableView;
@property(nonatomic, strong) UIView *newsBG;
@property(nonatomic, strong) XLCycleScrollView *newsView;
@end
