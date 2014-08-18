//
//  ValueTableViewCell.h
//  ME
//
//  Created by qf on 14/8/18.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDProgressView.h"


@interface ValueTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic)	NSInteger value;
@property (nonatomic,strong) ZDProgressView	*progressView;
- (id)initWithValue:(NSInteger)value andName:(NSString *)name;
@end
