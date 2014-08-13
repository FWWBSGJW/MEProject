//
//  CMoreActionView.h
//  ME
//
//  Created by yato_kami on 14-8-7.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMoreActionView : UIView
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIButton *peopleButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (assign, nonatomic) BOOL isShow;

- (void)showMoreActionView;
- (void)disMissMoreActionView;

@end
