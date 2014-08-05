//
//  QATableViewCell.h
//  ME
//
//  Created by qf on 14/8/5.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QATableViewCell : UITableViewCell
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *content;
- (void)setUI;
@end
