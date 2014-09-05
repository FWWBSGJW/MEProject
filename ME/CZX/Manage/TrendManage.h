//
//  TrendManage.h
//  ME
//
//  Created by Johnny's on 14-9-5.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrendsViewController.h"

@interface TrendManage : NSObject

- (void)saveDirectionModel:(NSArray *)paramArray;
- (NSArray *)analyseJsonForVC:(TrendsViewController *)vc;
- (void)getData:(TrendsViewController *)vc;
- (NSArray *)getUrlTrends:(NSString *)paramUrl;
@end
