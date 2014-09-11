//
//  TrendModel.m
//
//  Created by  C陈政旭 on 14-9-10
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "TrendModel.h"


NSString *const kTrendModelHmtime = @"hmtime";
NSString *const kTrendModelContent = @"content";
NSString *const kTrendModelUserId = @"userId";
NSString *const kTrendModelMid = @"mid";
NSString *const kTrendModelUserName = @"userName";
NSString *const kTrendModelUserPortrait = @"userPortrait";
NSString *const kTrendModelUrl = @"url";


@interface TrendModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation TrendModel

@synthesize hmtime = _hmtime;
@synthesize content = _content;
@synthesize userId = _userId;
@synthesize mid = _mid;
@synthesize userName = _userName;
@synthesize userPortrait = _userPortrait;
@synthesize url = _url;


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
            self.userId = [[self objectOrNilForKey:kTrendModelUserId fromDictionary:dict] doubleValue];
            self.mid = [[self objectOrNilForKey:kTrendModelMid fromDictionary:dict] doubleValue];
            self.userName = [self objectOrNilForKey:kTrendModelUserName fromDictionary:dict];
            self.userPortrait = [self objectOrNilForKey:kTrendModelUserPortrait fromDictionary:dict];
            self.url = [self objectOrNilForKey:kTrendModelUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.hmtime] forKey:kTrendModelHmtime];
    [mutableDict setValue:self.content forKey:kTrendModelContent];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kTrendModelUserId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.mid] forKey:kTrendModelMid];
    [mutableDict setValue:self.userName forKey:kTrendModelUserName];
    [mutableDict setValue:self.userPortrait forKey:kTrendModelUserPortrait];
    [mutableDict setValue:self.url forKey:kTrendModelUrl];

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
    self.userId = [aDecoder decodeDoubleForKey:kTrendModelUserId];
    self.mid = [aDecoder decodeDoubleForKey:kTrendModelMid];
    self.userName = [aDecoder decodeObjectForKey:kTrendModelUserName];
    self.userPortrait = [aDecoder decodeObjectForKey:kTrendModelUserPortrait];
    self.url = [aDecoder decodeObjectForKey:kTrendModelUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_hmtime forKey:kTrendModelHmtime];
    [aCoder encodeObject:_content forKey:kTrendModelContent];
    [aCoder encodeDouble:_userId forKey:kTrendModelUserId];
    [aCoder encodeDouble:_mid forKey:kTrendModelMid];
    [aCoder encodeObject:_userName forKey:kTrendModelUserName];
    [aCoder encodeObject:_userPortrait forKey:kTrendModelUserPortrait];
    [aCoder encodeObject:_url forKey:kTrendModelUrl];
}

- (id)copyWithZone:(NSZone *)zone
{
    TrendModel *copy = [[TrendModel alloc] init];
    
    if (copy) {

        copy.hmtime = self.hmtime;
        copy.content = [self.content copyWithZone:zone];
        copy.userId = self.userId;
        copy.mid = self.mid;
        copy.userName = [self.userName copyWithZone:zone];
        copy.userPortrait = [self.userPortrait copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
