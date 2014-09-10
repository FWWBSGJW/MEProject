//
//  TrendDetailViewController.h
//  ME
//
//  Created by Johnny's on 14-9-5.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendModel.h"

@interface TrendDetailViewController : UIViewController

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) UIImageView *userHeadImage;
@property(nonatomic, strong) UILabel *trendLabel;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) NSArray *commentArray;

@property(nonatomic, strong) UITableView *commentTableView;

- (id)initWithTrendModel:(TrendModel *)model;
@end
