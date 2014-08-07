//
//  RankingViewController.h
//  ME
//
//  Created by Johnny's on 14-8-7.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
- (IBAction)selectRanking:(id)sender;

@property(nonatomic, strong) UITableView *rankTableView;
@property(nonatomic, strong) UIPickerView *myPickerView;
@end