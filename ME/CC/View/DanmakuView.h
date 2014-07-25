//
//  DanmakuView.h
//  移动教育1.0
//
//  Created by yato_kami on 14-7-14.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DanmakuView : UILabel

//根据文字调节label的frame

- (void)setSizeWithComponent:(NSString *)string;

- (void)setStaticDMSizeWithComponent:(NSString *)string;

- (instancetype)initStaticDM;

- (instancetype)initMoveDM;



@end
