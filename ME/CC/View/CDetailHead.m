//
//  CDetailHead.m
//  移动教育1.0
//
//  Created by yato_kami on 14-7-6.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "CDetailHead.h"

@implementation CDetailHead

- (id)initWithFrame:(CGRect)frame
{
    //self = [super initWithFrame:frame];
    //UINib *nib = [UINib nibWithNibName:@"CDetailHead.xib" bundle:[NSBundle mainBundle]];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CDetailHead" owner:self options:nil];
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

- (IBAction)showMoreButton:(id)sender {
}
@end
