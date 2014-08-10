//
//  RankingViewController.h
//  ME
//
//  Created by Johnny's on 14-8-7.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, strong) UITableView *rankTableView;
@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, strong) NSArray *rankShowArray;
@property(nonatomic, strong) UIActivityIndicatorView *activityView;
@property(nonatomic, strong) NSArray *directionPowerArray;
@property(nonatomic, strong) NSArray *directionTestArray;
@property(nonatomic, strong) NSMutableArray *testArray;
@property(nonatomic, strong) NSArray *showTestArray;
@end