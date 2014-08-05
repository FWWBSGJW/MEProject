//
//  SendComNoteView.m
//  ME
//
//  Created by yato_kami on 14-7-23.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "SendComNoteView.h"

@implementation SendComNoteView

- (id)init
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SendComNoteView" owner:self options:nil];
    self = nib[0];
    if (self) {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
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
