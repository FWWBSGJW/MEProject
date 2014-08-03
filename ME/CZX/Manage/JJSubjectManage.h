//
//  JJSubjectManage.h
//  ME
//
//  Created by Johnny's on 14-7-24.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJSubjectModel.h"
#import "JJTestDetailViewController.h"
#import "JJMeasurementViewController.h"

@interface JJSubjectManage : NSObject

- (NSArray *)analyseSubjectJson:(NSString *)paramUrl forSubjectVC:(JJMeasurementViewController *)paramVC;
- (NSArray *)queryModels;
- (void)saveDirectionModel:(NSArray *)paramArray;
@end
