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
    CGSize size = CGSizeMake(150,200);
    NSDictionary *attribute = @{NSFontAttributeName: alertLabel.font};
    CGSize labelsize = [text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    [alertLabel setFrame:CGRectMake((SCREEN_WIDTH-labelsize.width*1.5)/2, (SCREEN_HEIGHT-labelsize.height*2)/2 - 40.0, labelsize.width*1.5, labelsize.height*2)];
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
    [self showWithShowSecond:0.8f andDisappearSecond:0.6f];
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
