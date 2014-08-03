//
//  RankingManage.h
//  ME
//
//  Created by Johnny's on 14-8-3.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RangkingModel.h"
#import "JJFinishViewController.h"

@interface RankingManage : NSObject

- (NSMutableArray *)analyseRankingJsonForVC:(JJFinishViewController *)paramVC withUrl:(NSString *)paramurl;
@end
