//
//  QATableViewController.h
//  ME
//
//  Created by qf on 14/8/5.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, QAStyle){
	QAStyleQuestion,
	QAStyleAnswer
};

@interface QATableViewController : UITableViewController
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic) QAStyle style;
@end
