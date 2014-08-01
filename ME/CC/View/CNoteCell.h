//
//  CNoteCell.h
//  ME
//
//  Created by yato_kami on 14-8-1.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNoteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *chapterLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
