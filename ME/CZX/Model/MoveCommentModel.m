//
//  MoveCommentModel.m
//
//  Created by  C陈政旭 on 14-9-10
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "MoveCommentModel.h"


NSString *const kMoveCommentModelComment = @"comment";
NSString *const kMoveCommentModelUserPortrait = @"userPortrait";
NSString *const kMoveCommentModelUserName = @"userName";


@interface MoveCommentModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MoveCommentModel

@synthesize comment = _comment;
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
            self.comment = [self objectOrNilForKey:kMoveCommentModelComment fromDictionary:dict];
            self.userPortrait = [self objectOrNilForKey:kMoveCommentModelUserPortrait fromDictionary:dict];
            self.userName = [self objectOrNilForKey:kMoveCommentModelUserName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.comment forKey:kMoveCommentModelComment];
    [mutableDict setValue:self.userPortrait forKey:kMoveCommentModelUserPortrait];
    [mutableDict setValue:self.userName forKey:kMoveCommentModelUserName];

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

    self.comment = [aDecoder decodeObjectForKey:kMoveCommentModelComment];
    self.userPortrait = [aDecoder decodeObjectForKey:kMoveCommentModelUserPortrait];
    self.userName = [aDecoder decodeObjectForKey:kMoveCommentModelUserName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_comment forKey:kMoveCommentModelComment];
    [aCoder encodeObject:_userPortrait forKey:kMoveCommentModelUserPortrait];
    [aCoder encodeObject:_userName forKey:kMoveCommentModelUserName];
}

- (id)copyWithZone:(NSZone *)zone
{
    MoveCommentModel *copy = [[MoveCommentModel alloc] init];
    
    if (copy) {

        copy.comment = [self.comment copyWithZone:zone];
        copy.userPortrait = [self.userPortrait copyWithZone:zone];
        copy.userName = [self.userName copyWithZone:zone];
    }
    
    return copy;
}


@end
