//
//  CChapterHead.m
//  移动教育1.0
//
//  Created by yato_kami on 14-7-7.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "CChapterHead.h"

@implementation CChapterHead

- (id)initWithFrame:(CGRect)frame
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CChapterHead" owner:self options:nil];
    self = nib[0];
    if (self) {
        // Initialization code
    }
    return self;
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
