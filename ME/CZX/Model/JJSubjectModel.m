//
//  JJSubjectModel.m
//  ME
//
//  Created by Johnny's on 14-7-24.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "JJSubjectModel.h"

@implementation JJSubjectModel

- (void)setSubjectModelWithDictionary:(NSDictionary *)dict
{
    _ceAnswer = [dict objectForKey:@"ceAnswer"];
    _ceContext = [dict objectForKey:@"ceContext"];
    _ceId = [[dict objectForKey:@"ceId"] intValue];
    NSDictionary *mydict = [dict objectForKey:@"options"];
    _options = [[NSMutableArray alloc] init];
    [_options addObject:[mydict objectForKey:@"ceA"]];
    [_options addObject:[mydict objectForKey:@"ceB"]];
    [_options addObject:[mydict objectForKey:@"ceC"]];
    [_options addObject:[mydict objectForKey:@"ceD"]];
}

@end
