//
//  JJDirectionModel.m
//  在线教育
//
//  Created by Johnny's on 14-7-23.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "JJDirectionModel.h"

@implementation JJDirectionModel

- (void)setDirectionModelWithDictionary:(NSDictionary *)dict
{
    _tdLink = [dict objectForKey:@"tdLink"];
    _tdId = [[dict objectForKey:@"tdId"] intValue];
    _tdName = [dict objectForKey:@"tdName"];
    _tdDetail = [dict objectForKey:@"tdDetail"];
    _tdPic = [dict objectForKey:@"tdPic"];
    _tdpersonnum = [[dict objectForKey:@"tdpersonnum"] intValue];
    _testnum = [[dict objectForKey:@"testnum"] intValue];
}

@end
