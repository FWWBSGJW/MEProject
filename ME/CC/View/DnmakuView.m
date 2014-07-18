//
//  DanmakuView.m
//  移动教育1.0
//
//  Created by yato_kami on 14-7-14.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "DanmakuView.h"

@implementation DanmakuView

- (void)setSizeWithComponent:(NSString *)string
{
    self.text = string;
    CGSize size = CGSizeMake(2000,50);
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    CGSize labelsize = [string boundingRectWithSize:size options:NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    [self setFrame:CGRectMake(0, 0, labelsize.width, labelsize.height)];
}

- (instancetype)init
{
    self = [super init];
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor whiteColor];
    [self setFont:[UIFont fontWithName:@"Arial" size:18]];
    [self setShadowColor:[UIColor blackColor]];
    [self setShadowOffset:CGSizeMake(1.0, 2.0)];
    
    return self;
}

//- (void)setSelfSizeWithString:(NSString *)string
//{
//    //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];//后面还会重新设置其size。
//    [self setNumberOfLines:1];
//    //NSString *s = @"string......";
//    UIFont *font =
//    CGSize size = CGSizeMake(320,2000);
//    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//    [label setFrame:CGRectMake(0, 0, labelsize.width, labelsize.height)];
//    [self.view addSubView:label];
//
//}


@end
