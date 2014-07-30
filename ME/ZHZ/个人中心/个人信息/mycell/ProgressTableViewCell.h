//
//  GuageTableViewCell.h
//  Online_learning
//
//  Created by qf on 14/7/10.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDProgressView.h"
@interface ProgressTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong)  ZDProgressView *progressView;
@property (nonatomic,weak) IBOutlet UIImageView *courseImage;

@end
