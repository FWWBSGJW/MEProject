//
//  RangkingModel.m
//
//  Created by  C陈政旭 on 14-8-2
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "RangkingModel.h"


NSString *const kRangkingModelUserPortrait = @"userPortrait";
NSString *const kRangkingModelScore = @"score";
NSString *const kRangkingModelTime = @"time";
NSString *const kRangkingModelUserName = @"userName";


@interface RangkingModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RangkingModel

@synthesize userPortrait = _userPortrait;
@synthesize score = _score;
@synthesize time = _time;
@synthesize userName = _userName;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]])
    {
        self.userPortrait = [self objectOrNilForKey:kRangkingModelUserPortrait fromDictionary:dict];
        self.score = [[self objectOrNilForKey:kRangkingModelScore fromDictionary:dict] doubleValue];
        self.time = [[self objectOrNilForKey:kRangkingModelTime fromDictionary:dict] doubleValue];
            self.userName = [self objectOrNilForKey:kRangkingModelUserName fromDictionary:dict];

    }
    
    return self;
    
}

//- (NSDictionary *)dictionaryRepresentation
//{
//    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
//    [mutableDict setValue:self.userPortrait forKey:kRangkingModelUserPortrait];
//    [mutableDict setValue:[NSNumber numberWithDouble:self.score] forKey:kRangkingModelScore];
//    [mutableDict setValue:self.time forKey:kRangkingModelTime];
//    [mutableDict setValue:self.userName forKey:kRangkingModelUserName];
//
//    return [NSDictionary dictionaryWithDictionary:mutableDict];
//}

//- (NSString *)description 
//{
//    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
//}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super init];
//
//    self.userPortrait = [aDecoder decodeObjectForKey:kRangkingModelUserPortrait];
//    self.score = [aDecoder decodeDoubleForKey:kRangkingModelScore];
//    self.time = [aDecoder decodeObjectForKey:kRangkingModelTime];
//    self.userName = [aDecoder decodeObjectForKey:kRangkingModelUserName];
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//
//    [aCoder encodeObject:_userPortrait forKey:kRangkingModelUserPortrait];
//    [aCoder encodeDouble:_score forKey:kRangkingModelScore];
//    [aCoder encodeObject:_time forKey:kRangkingModelTime];
//    [aCoder encodeObject:_userName forKey:kRangkingModelUserName];
//}
//
//- (id)copyWithZone:(NSZone *)zone
//{
//    RangkingModel *copy = [[RangkingModel alloc] init];
//    
//    if (copy) {
//
//        copy.userPortrait = [self.userPortrait copyWithZone:zone];
//        copy.score = self.score;
//        copy.time = self.time;
//        copy.userName = [self.userName copyWithZone:zone];
//    }
//    
//    return copy;
//}


@end
