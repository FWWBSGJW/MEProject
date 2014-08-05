//
//  JJCommentModel.m
//
//  Created by  C陈政旭 on 14-7-29
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "JJCommentModel.h"


NSString *const kJJCommentModelCcId = @"ccId";
NSString *const kJJCommentModelUserPortrait = @"userPortrait";
NSString *const kJJCommentModelUserSign = @"userName";
NSString *const kJJCommentModelUserid = @"userid";
NSString *const kJJCommentModelCcContent = @"ccContent";
NSString *const kJJCommentModelCcDate = @"ccDate";


@interface JJCommentModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation JJCommentModel

@synthesize ccId = _ccId;
@synthesize userPortrait = _userPortrait;
@synthesize userSign = _userSign;
@synthesize userid = _userid;
@synthesize ccContent = _ccContent;
@synthesize ccDate = _ccDate;


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
            self.ccId = [[self objectOrNilForKey:kJJCommentModelCcId fromDictionary:dict] doubleValue];
            self.userPortrait = [self objectOrNilForKey:kJJCommentModelUserPortrait fromDictionary:dict];
            self.userSign = [self objectOrNilForKey:kJJCommentModelUserSign fromDictionary:dict];
            self.userid = [[self objectOrNilForKey:kJJCommentModelUserid fromDictionary:dict] doubleValue];
            self.ccContent = [self objectOrNilForKey:kJJCommentModelCcContent fromDictionary:dict];
            self.ccDate = [self objectOrNilForKey:kJJCommentModelCcDate fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.ccId] forKey:kJJCommentModelCcId];
    [mutableDict setValue:self.userPortrait forKey:kJJCommentModelUserPortrait];
    [mutableDict setValue:self.userSign forKey:kJJCommentModelUserSign];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userid] forKey:kJJCommentModelUserid];
    [mutableDict setValue:self.ccContent forKey:kJJCommentModelCcContent];
    [mutableDict setValue:self.ccDate forKey:kJJCommentModelCcDate];

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

    self.ccId = [aDecoder decodeDoubleForKey:kJJCommentModelCcId];
    self.userPortrait = [aDecoder decodeObjectForKey:kJJCommentModelUserPortrait];
    self.userSign = [aDecoder decodeObjectForKey:kJJCommentModelUserSign];
    self.userid = [aDecoder decodeDoubleForKey:kJJCommentModelUserid];
    self.ccContent = [aDecoder decodeObjectForKey:kJJCommentModelCcContent];
    self.ccDate = [aDecoder decodeObjectForKey:kJJCommentModelCcDate];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_ccId forKey:kJJCommentModelCcId];
    [aCoder encodeObject:_userPortrait forKey:kJJCommentModelUserPortrait];
    [aCoder encodeObject:_userSign forKey:kJJCommentModelUserSign];
    [aCoder encodeDouble:_userid forKey:kJJCommentModelUserid];
    [aCoder encodeObject:_ccContent forKey:kJJCommentModelCcContent];
    [aCoder encodeObject:_ccDate forKey:kJJCommentModelCcDate];
}

- (id)copyWithZone:(NSZone *)zone
{
    JJCommentModel *copy = [[JJCommentModel alloc] init];
    
    if (copy) {

        copy.ccId = self.ccId;
        copy.userPortrait = [self.userPortrait copyWithZone:zone];
        copy.userSign = [self.userSign copyWithZone:zone];
        copy.userid = self.userid;
        copy.ccContent = [self.ccContent copyWithZone:zone];
        copy.ccDate = [self.ccDate copyWithZone:zone];
    }
    
    return copy;
}


@end
