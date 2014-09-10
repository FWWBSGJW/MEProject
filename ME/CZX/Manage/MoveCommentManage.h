//
//  MoveCommentManage.h
//  ME
//
//  Created by Johnny's on 14-9-10.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoveCommentModel.h"
#import "TrendDetailViewController.h"

@interface MoveCommentManage : NSObject

- (NSMutableArray *)analyseCommentJsonForVC:(TrendDetailViewController *)paramVC withCommentUrl:(NSString *)paramUrl;
- (NSMutableArray *)analyseCommentJsonWithCommentUrl:(NSString *)paramUrl;

@end
