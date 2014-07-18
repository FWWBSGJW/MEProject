//
//  JJMeasurementViewController.h
//  在线教育
//
//  Created by Johnny's on 14-7-10.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "JJBaseViewController.h"

@interface JJMeasurementViewController : JJBaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UIButton *upBtn;
@property (strong, nonatomic) UIButton *downBtn;

@end
