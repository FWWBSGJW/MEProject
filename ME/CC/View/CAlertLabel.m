//
//  CAlertLabel.m
//  ME
//
//  Created by yato_kami on 14-8-5.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "CAlertLabel.h"

@implementation CAlertLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (instancetype)alertLabelWithFrame:(CGRect)frame andText:(NSString *)text
{
    CAlertLabel *alertLabel = [[CAlertLabel alloc] initWithFrame:frame];
    alertLabel.layer.cornerRadius = 10;
    alertLabel.layer.masksToBounds = YES;
    alertLabel.backgroundColor = [UIColor blackColor];
    alertLabel.alpha = 0.9f;
    alertLabel.textColor = [UIColor whiteColor];
    [alertLabel setTextAlignment:NSTextAlignmentCenter];
    [alertLabel setLineBreakMode:NSLineBreakByCharWrapping];
    alertLabel.numberOfLines = 0;
    alertLabel.font = [UIFont systemFontOfSize:13.0];
    alertLabel.text = text;
    return alertLabel;
}

+ (instancetype)alertLabelWithAdjustFrameForText: (NSString *)text
{
    CAlertLabel *alertLabel = [CAlertLabel alertLabelWithFrame:CGRectZero andText:text];
    //alertLabel.text = string;
    CGSize size = CGSizeMake(155,155);
    NSDictionary *attribute = @{NSFontAttributeName: alertLabel.font};
    CGSize labelsize = [text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    CGFloat labelWidth = labelsize.width*1.6 < 120 ? 120:labelsize.width*1.6;
    labelWidth = labelWidth < 155 ? labelWidth:155;
    CGFloat labelHeight = labelsize.height*1.5 < 70 ? 70:labelsize.height*1.5;
    labelHeight = labelHeight < 155 ? labelHeight:155;
    NSLog(@"%f--%f-",labelWidth,labelHeight);
    [alertLabel setFrame:CGRectMake((SCREEN_WIDTH-labelWidth)/2, (SCREEN_HEIGHT-labelHeight)/2 - 50.0, labelWidth, labelHeight)];
    return alertLabel;
}

- (void)showWithShowSecond:(CGFloat)showSecond andDisappearSecond:(CGFloat)disSecond
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:disSecond delay:showSecond options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showAlertLabel
{
    [self showWithShowSecond:1.0f andDisappearSecond:0.6f];
}

+ (instancetype)alertLabelInHeadForText:(NSString *)text andIsHaveNavigationBar:(BOOL)isHave{
    CAlertLabel *alertLabel = [[CAlertLabel alloc] initWithFrame:CGRectMake(0, isHave?64.0:20.0, SCREEN_WIDTH, 30)];
    alertLabel.backgroundColor = System_BlueColor;
    alertLabel.alpha = 0.9f;
    alertLabel.textColor = [UIColor whiteColor];
    [alertLabel setTextAlignment:NSTextAlignmentCenter];
    alertLabel.numberOfLines = 1;
    alertLabel.font = [UIFont systemFontOfSize:13.0];
    alertLabel.text = text;
    return alertLabel;
}

- (void)showAlertLabelForHead
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.9f delay:1.2f options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
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
