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

- (void)setStaticDMSizeWithComponent:(NSString *)string
{
    self.text = string;
    CGSize size = CGSizeMake(SCREEN_HEIGHT/2.0, SCREEN_WIDTH/2.0);
    //    获取当前文本的属性
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName,nil];
    //ios7方法，获取文本需要的size，限制宽度
    CGSize fitSize = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    self.frame =CGRectMake(0,0, fitSize.width, fitSize.height);
}

- (instancetype)initMoveDM
{
    self = [super init];
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor whiteColor];
    [self setFont:[UIFont fontWithName:@"Arial" size:18]];
    [self setShadowColor:[UIColor blackColor]];
    [self setShadowOffset:CGSizeMake(1.0, 2.0)];
    
    return self;
}

- (instancetype)initStaticDM
{
    self = [self initMoveDM];
    self.numberOfLines = 0;
    [self setLineBreakMode:NSLineBreakByCharWrapping];
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
