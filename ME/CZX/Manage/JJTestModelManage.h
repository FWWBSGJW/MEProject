//
//  JJTestModelManage.h
//  ME
//
//  Created by Johnny's on 14-7-23.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJTestModel.h"
#import "JJTestDivideViewController.h"

@interface JJTestModelManage : NSObject

- (NSArray *)analyseTestJson:(NSString *)paramUrl forVC:(JJTestDivideViewController *)paramVC;
- (NSArray *)analyseTestJson:(NSString *)paramUrl;

@end
