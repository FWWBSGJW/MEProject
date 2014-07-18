//
//  UINavigationController+autoRotate.m
//  移动教育1.0
//
//  Created by yato_kami on 14-7-11.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "UINavigationController+autoRotate.h"

@implementation UINavigationController (autoRotate)

- (BOOL)shouldAutorotate {
    //return [self.visibleViewController shouldAutorotate];
    return [self.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    //return [self.visibleViewController supportedInterfaceOrientations];
    return [self.topViewController supportedInterfaceOrientations];
}

@end
