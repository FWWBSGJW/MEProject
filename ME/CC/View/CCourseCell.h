//
//  CCourseCell.h
//  移动教育1.0
//
//  Created by yato_kami on 14-7-4.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCourseCell : UITableViewCell

//课程方向图片
@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
//课程方向标题
@property (weak, nonatomic) IBOutlet UILabel *courseHeadLabel;
//课程方向介绍label
@property (weak, nonatomic) IBOutlet UILabel *courseDetailLabel;
//课程学习人数label
@property (weak, nonatomic) IBOutlet UILabel *coursePeopleNumLabel;
//课程总时间数label
@property (weak, nonatomic) IBOutlet UILabel *CoursetTimeLabel;


@end
