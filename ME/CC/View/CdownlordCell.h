//
//  CdownlordCell.h
//  ME
//
//  Created by yato_kami on 14-8-6.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol dCelldelegate <NSObject>

- (void)touchStartorPauseButton:(UIButton *)sender;

@end

@interface CdownlordCell : UITableViewCell

@property (weak, nonatomic) id<dCelldelegate> cellDelegate;

@property (weak, nonatomic) IBOutlet UIImageView *dFileImageView;
@property (weak, nonatomic) IBOutlet UILabel *dTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dhadDownNumber;
@property (weak, nonatomic) IBOutlet UILabel *dShouldDownNumber;
@property (weak, nonatomic) IBOutlet UILabel *dStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *dDownloadButton;

@end
