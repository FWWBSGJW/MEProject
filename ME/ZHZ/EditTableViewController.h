//
//  EditTableViewController.h
//  ME
//
//  Created by qf on 14/8/9.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTableViewController : UITableViewController <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *describtion;

@end
