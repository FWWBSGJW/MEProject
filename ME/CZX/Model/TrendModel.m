//
//  TrendModel.m
//
//  Created by  C陈政旭 on 14-9-5
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "TrendModel.h"


NSString *const kTrendModelHmtime = @"hmtime";
NSString *const kTrendModelContent = @"content";
NSString *const kTrendModelMid = @"mid";
NSString *const kTrendModelUrl = @"url";
NSString *const kTrendModelUserPortrait = @"userPortrait";
NSString *const kTrendModelUserName = @"userName";


@interface TrendModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation TrendModel

@synthesize hmtime = _hmtime;
@synthesize content = _content;
@synthesize mid = _mid;
@synthesize url = _url;
@synthesize userPortrait = _userPortrait;
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
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.hmtime = [[self objectOrNilForKey:kTrendModelHmtime fromDictionary:dict] doubleValue];
            self.content = [self objectOrNilForKey:kTrendModelContent fromDictionary:dict];
            self.mid = [[self objectOrNilForKey:kTrendModelMid fromDictionary:dict] doubleValue];
            self.url = [self objectOrNilForKey:kTrendModelUrl fromDictionary:dict];
            self.userPortrait = [self objectOrNilForKey:kTrendModelUserPortrait fromDictionary:dict];
            self.userName = [self objectOrNilForKey:kTrendModelUserName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.hmtime] forKey:kTrendModelHmtime];
    [mutableDict setValue:self.content forKey:kTrendModelContent];
    [mutableDict setValue:[NSNumber numberWithDouble:self.mid] forKey:kTrendModelMid];
    [mutableDict setValue:self.url forKey:kTrendModelUrl];
    [mutableDict setValue:self.userPortrait forKey:kTrendModelUserPortrait];
    [mutableDict setValue:self.userName forKey:kTrendModelUserName];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.hmtime = [aDecoder decodeDoubleForKey:kTrendModelHmtime];
    self.content = [aDecoder decodeObjectForKey:kTrendModelContent];
    self.mid = [aDecoder decodeDoubleForKey:kTrendModelMid];
    self.url = [aDecoder decodeObjectForKey:kTrendModelUrl];
    self.userPortrait = [aDecoder decodeObjectForKey:kTrendModelUserPortrait];
    self.userName = [aDecoder decodeObjectForKey:kTrendModelUserName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_hmtime forKey:kTrendModelHmtime];
    [aCoder encodeObject:_content forKey:kTrendModelContent];
    [aCoder encodeDouble:_mid forKey:kTrendModelMid];
    [aCoder encodeObject:_url forKey:kTrendModelUrl];
    [aCoder encodeObject:_userPortrait forKey:kTrendModelUserPortrait];
    [aCoder encodeObject:_userName forKey:kTrendModelUserName];
}

- (id)copyWithZone:(NSZone *)zone
{
    TrendModel *copy = [[TrendModel alloc] init];
    
    if (copy) {

        copy.hmtime = self.hmtime;
        copy.content = [self.content copyWithZone:zone];
        copy.mid = self.mid;
        copy.url = [self.url copyWithZone:zone];
        copy.userPortrait = [self.userPortrait copyWithZone:zone];
        copy.userName = [self.userName copyWithZone:zone];
    }
    
    return copy;
}


@end
