//
//  ResultBase.m
//
//  Created by  C陈政旭 on 14-9-11
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ResultBase.h"


NSString *const kResultBaseCName = @"cName";
NSString *const kResultBaseUserPortrait = @"userPortrait";
NSString *const kResultBaseUserName = @"userName";
NSString *const kResultBaseUserId = @"userId";
NSString *const kResultBaseCPic = @"cPic";
NSString *const kResultBaseCid = @"cid";


@interface ResultBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ResultBase

@synthesize cName = _cName;
@synthesize userPortrait = _userPortrait;
@synthesize userName = _userName;
@synthesize userId = _userId;
@synthesize cPic = _cPic;
@synthesize cid = _cid;


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
            self.cName = [self objectOrNilForKey:kResultBaseCName fromDictionary:dict];
            self.userPortrait = [self objectOrNilForKey:kResultBaseUserPortrait fromDictionary:dict];
            self.userName = [self objectOrNilForKey:kResultBaseUserName fromDictionary:dict];
            self.userId = [[self objectOrNilForKey:kResultBaseUserId fromDictionary:dict] doubleValue];
            self.cPic = [self objectOrNilForKey:kResultBaseCPic fromDictionary:dict];
            self.cid = [[self objectOrNilForKey:kResultBaseCid fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.cName forKey:kResultBaseCName];
    [mutableDict setValue:self.userPortrait forKey:kResultBaseUserPortrait];
    [mutableDict setValue:self.userName forKey:kResultBaseUserName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kResultBaseUserId];
    [mutableDict setValue:self.cPic forKey:kResultBaseCPic];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cid] forKey:kResultBaseCid];

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

    self.cName = [aDecoder decodeObjectForKey:kResultBaseCName];
    self.userPortrait = [aDecoder decodeObjectForKey:kResultBaseUserPortrait];
    self.userName = [aDecoder decodeObjectForKey:kResultBaseUserName];
    self.userId = [aDecoder decodeDoubleForKey:kResultBaseUserId];
    self.cPic = [aDecoder decodeObjectForKey:kResultBaseCPic];
    self.cid = [aDecoder decodeDoubleForKey:kResultBaseCid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_cName forKey:kResultBaseCName];
    [aCoder encodeObject:_userPortrait forKey:kResultBaseUserPortrait];
    [aCoder encodeObject:_userName forKey:kResultBaseUserName];
    [aCoder encodeDouble:_userId forKey:kResultBaseUserId];
    [aCoder encodeObject:_cPic forKey:kResultBaseCPic];
    [aCoder encodeDouble:_cid forKey:kResultBaseCid];
}

- (id)copyWithZone:(NSZone *)zone
{
    ResultBase *copy = [[ResultBase alloc] init];
    
    if (copy) {

        copy.cName = [self.cName copyWithZone:zone];
        copy.userPortrait = [self.userPortrait copyWithZone:zone];
        copy.userName = [self.userName copyWithZone:zone];
        copy.userId = self.userId;
        copy.cPic = [self.cPic copyWithZone:zone];
        copy.cid = self.cid;
    }
    
    return copy;
}


@end
