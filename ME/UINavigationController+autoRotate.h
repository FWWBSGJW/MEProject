//
//  UINavigationController+autoRotate.h
//  移动教育1.0
//
//  Created by yato_kami on 14-7-11.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (autoRotate)

-(BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;

@end
