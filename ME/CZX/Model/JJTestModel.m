//
//  JJTestModel.m
//  在线教育
//
//  Created by Johnny's on 14-7-9.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "JJTestModel.h"

@implementation JJTestModel

- (void)setTestModelWithDictionary:(NSDictionary *)dict
{
    _highScoreUrl = [dict objectForKey:@"highScoreUrl"];
    _subjectnums = [[dict objectForKey:@"subjectnums"] intValue];
    _sublink = [dict objectForKey:@"sublink"];
    _tcId = [[dict objectForKey:@"tcId"] intValue];
    _tcIntro = [dict objectForKey:@"tcIntro"];
    _tcName = [dict objectForKey:@"tcName"];
    _tcPhotoUrl = [dict objectForKey:@"tcPhotoUrl"];
    _tcNum = [[dict objectForKey:@"tcNum"] intValue];
    _tcPrice = [[dict objectForKey:@"tcPrice"] intValue];
    _tcScore = [[dict objectForKey:@"tcScore"] intValue];
    _tcTime = [[dict objectForKey:@"tcTime"] intValue];
    _tdirection = [[dict objectForKey:@"tdirection"] intValue];
    _nextPage = [dict objectForKey:@"nextPage"];
    _commentLink = [dict objectForKey:@"commentLink"];
}
@end
