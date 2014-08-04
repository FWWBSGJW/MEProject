//
//  SingleTestManage.h
//  ME
//
//  Created by Johnny's on 14-8-4.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJTestModel.h"
#import "JJTestDetailViewController.h"

@interface SingleTestManage : NSObject
- (JJTestModel *)analyseTestJson:(NSString *)paramUrl;
@end
