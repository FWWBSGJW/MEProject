//
//  CDetailHead.h
//  移动教育1.0
//
//  Created by yato_kami on 14-7-6.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDetailHead : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *videoNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *practiceNumLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;


@end
