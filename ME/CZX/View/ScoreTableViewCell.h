//
//  ScoreTableViewCell.h
//  ME
//
//  Created by Johnny's on 14-8-1.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headView;
@property (strong, nonatomic) IBOutlet UILabel *nameLa;
@property (strong, nonatomic) IBOutlet UILabel *scoreLa;
@property (strong, nonatomic) IBOutlet UILabel *timeLa;
@property (strong, nonatomic) IBOutlet UILabel *rankingLa;
@property (strong, nonatomic) IBOutlet UIButton *imageBtn;
@property (strong, nonatomic) IBOutlet UIButton *dismissBtn;

@end
