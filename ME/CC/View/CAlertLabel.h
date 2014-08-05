//
//  CAlertView.h
//  ME
//
//  Created by yato_kami on 14-8-5.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAlertLabel : UILabel

/**
 *  按照给定text内容，创建CAlertLebel，并自动调节本试图位置与大小，无需设frame，随便写的，估计不怎么好用（笑
 *
 *  @param text 内容文字
 *
 *  @return 实例对象
 */
+ (instancetype)alertLabelWithAdjustFrameForText: (NSString *)text;

/**
 *  根据自己给定的frame以及text创建CAlertView
 *
 *  @param frame frame
 *  @param text  内容文字
 *
 *  @return 实例对象
 */
+ (instancetype)alertLabelWithFrame:(CGRect)frame andText:(NSString *)text;

/**
 *  根据初始参数show本试图，并开始动画自动消失
 */
- (void)showAlertLabel;

/**
 *  定制动画时间
 *
 *  @param showSecond 本试图在屏幕出现时间（不包括消失那段时间）
 *  @param disSecond  逐渐消失的动画持续时间
 */
- (void)showWithShowSecond:(CGFloat)showSecond andDisappearSecond:(CGFloat)disSecond;

@end
