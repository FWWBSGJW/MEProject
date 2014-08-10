//
//  testModelBaseClass.m
//
//  Created by  C陈政旭 on 14-8-10
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "testModelBaseClass.h"


NSString *const ktestModelBaseClassTcName = @"tcName";
NSString *const ktestModelBaseClassTcId = @"tcId";


@interface testModelBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation testModelBaseClass

@synthesize tcName = _tcName;
@synthesize tcId = _tcId;


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
            self.tcName = [self objectOrNilForKey:ktestModelBaseClassTcName fromDictionary:dict];
            self.tcId = [[self objectOrNilForKey:ktestModelBaseClassTcId fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.tcName forKey:ktestModelBaseClassTcName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.tcId] forKey:ktestModelBaseClassTcId];

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

    self.tcName = [aDecoder decodeObjectForKey:ktestModelBaseClassTcName];
    self.tcId = [aDecoder decodeDoubleForKey:ktestModelBaseClassTcId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_tcName forKey:ktestModelBaseClassTcName];
    [aCoder encodeDouble:_tcId forKey:ktestModelBaseClassTcId];
}

- (id)copyWithZone:(NSZone *)zone
{
    testModelBaseClass *copy = [[testModelBaseClass alloc] init];
    
    if (copy) {

        copy.tcName = [self.tcName copyWithZone:zone];
        copy.tcId = self.tcId;
    }
    
    return copy;
}


@end
