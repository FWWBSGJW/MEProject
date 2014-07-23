//
//  JJTestTableViewCell.h
//  TestVC
//
//  Created by Johnny's on 14-7-4.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJTestTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *detailLa;
@property (strong, nonatomic) IBOutlet UILabel *personNums;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@end
