//
//  CChapterHead.h
//  移动教育1.0
//
//  Created by yato_kami on 14-7-7.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CChapterHead : UIView
@property (weak, nonatomic) IBOutlet UIImageView *CCImageView;
@property (weak, nonatomic) IBOutlet UILabel *CCtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *CCtypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *CCteacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *CCpriceLaebl;
@property (weak, nonatomic) IBOutlet UILabel *CCpointLabel;

//segementControl
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end
