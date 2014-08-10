//
//  FocusTableViewController.h
//  Online_learning
//
//  Created by qf on 14/7/9.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListInfo.h"

/**
 *		关注人列表
 *		1.UITableViewCellStyle = UITableViewCellStyleSubtitle
 */

@interface FocusTableViewController : UITableViewController
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) ListInfo *list;
- (id)initWithData:(NSArray *)data;
@end
