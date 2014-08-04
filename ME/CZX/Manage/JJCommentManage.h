//
//  JJCommentManage.h
//  ME
//
//  Created by Johnny's on 14-7-29.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJCommentModel.h"
#import "JJTestDetailViewController.h"

@interface JJCommentManage : NSObject

- (NSMutableArray *)analyseCommentJsonForVC:(JJTestDetailViewController *)paramVC withCommentUrl:(NSString *)paramUrl;
@end
