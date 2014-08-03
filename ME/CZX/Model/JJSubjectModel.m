//
//  JJSubjectModel.m
//  ME
//
//  Created by Johnny's on 14-7-24.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "JJSubjectModel.h"
#define kceAnswer @"ceAnswer"
#define kceContext @"ceContext"
#define kceId @"ceId"
#define koptions @"options"

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

#pragma mark-NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    
    [aCoder encodeObject:_ceAnswer forKey:kceAnswer];
    [aCoder encodeInt:_ceId forKey:kceId];
    [aCoder encodeObject:_ceContext forKey:kceContext];
    [aCoder encodeObject:_options forKey:koptions];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self == [super init]) {
        _ceAnswer =  [aDecoder decodeObjectForKey:kceAnswer];
        _ceId = [aDecoder decodeIntForKey:kceId];
        _ceContext =  [aDecoder decodeObjectForKey:kceContext];
        _options =  [aDecoder decodeObjectForKey:koptions];
    }
    
    return self;
}

@end
