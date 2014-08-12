//
//  DetailViewController.h
//  Online_learning
//
//  Created by qf on 14/7/9.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
@interface DetailViewController : UIViewController
@property (nonatomic,strong) UserInfo *userData;
- (id)initWithUserId:(NSInteger)userId;
@end
