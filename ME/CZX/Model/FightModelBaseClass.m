//
//  FightModelBaseClass.m
//
//  Created by  C陈政旭 on 14-8-10
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "FightModelBaseClass.h"


NSString *const kFightModelBaseClassCDid = @"CDid";
NSString *const kFightModelBaseClassCDhead = @"CDhead";


@interface FightModelBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FightModelBaseClass

@synthesize cDid = _cDid;
@synthesize cDhead = _cDhead;


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
            self.cDid = [[self objectOrNilForKey:kFightModelBaseClassCDid fromDictionary:dict] doubleValue];
            self.cDhead = [self objectOrNilForKey:kFightModelBaseClassCDhead fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cDid] forKey:kFightModelBaseClassCDid];
    [mutableDict setValue:self.cDhead forKey:kFightModelBaseClassCDhead];

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

    self.cDid = [aDecoder decodeDoubleForKey:kFightModelBaseClassCDid];
    self.cDhead = [aDecoder decodeObjectForKey:kFightModelBaseClassCDhead];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_cDid forKey:kFightModelBaseClassCDid];
    [aCoder encodeObject:_cDhead forKey:kFightModelBaseClassCDhead];
}

- (id)copyWithZone:(NSZone *)zone
{
    FightModelBaseClass *copy = [[FightModelBaseClass alloc] init];
    
    if (copy) {

        copy.cDid = self.cDid;
        copy.cDhead = [self.cDhead copyWithZone:zone];
    }
    
    return copy;
}


@end
