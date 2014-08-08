//
//  ShakeViewController.h
//  ME
//
//  Created by Johnny's on 14-8-7.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShakeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *phoneImageView;
@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@end
