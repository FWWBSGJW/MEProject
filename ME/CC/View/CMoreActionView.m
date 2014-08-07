//
//  CMoreActionView.m
//  ME
//
//  Created by yato_kami on 14-8-7.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "CMoreActionView.h"

#define myHeight 70.0
#define myWidth 100.0

@implementation CMoreActionView

- (id)initWithFrame:(CGRect)frame
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CMoreActionView" owner:self options:nil];
    self = nib[0];
    if (self) {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [[UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0] CGColor];

        self.layer.masksToBounds = YES;
        self.frame = CGRectMake(SCREEN_WIDTH, 64, 0, 0);
        self.isShow = NO;
    }
    return self;
}

- (void)showMoreActionView
{
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(SCREEN_WIDTH -myWidth-10 , 64.0, myWidth, myHeight);
    } completion:^(BOOL finished) {
        self.isShow = YES;
    }];
}

- (void)disMissMoreActionView
{
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(SCREEN_WIDTH, 64, 0, 0);
    } completion:^(BOOL finished) {
        self.isShow = NO;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
