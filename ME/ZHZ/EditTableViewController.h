//
//  EditTableViewController.h
//  ME
//
//  Created by qf on 14/8/9.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface EditTableViewController : UITableViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *describtion;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextFied;
@property (weak, nonatomic) IBOutlet UIImageView *portraitView;
@property (weak, nonatomic) IBOutlet UIImageView *maleImage;
@property (weak, nonatomic) IBOutlet UIImageView *femaleImage;
@property (nonatomic,strong) User *user;
@end
