//
//  TestDirectionBaseClass.m
//
//  Created by  C陈政旭 on 14-8-10
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "TestDirectionBaseClass.h"


NSString *const kTestDirectionBaseClassTdId = @"tdId";
NSString *const kTestDirectionBaseClassTdName = @"tdName";


@interface TestDirectionBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation TestDirectionBaseClass

@synthesize tdId = _tdId;
@synthesize tdName = _tdName;


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
            self.tdId = [[self objectOrNilForKey:kTestDirectionBaseClassTdId fromDictionary:dict] doubleValue];
            self.tdName = [self objectOrNilForKey:kTestDirectionBaseClassTdName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.tdId] forKey:kTestDirectionBaseClassTdId];
    [mutableDict setValue:self.tdName forKey:kTestDirectionBaseClassTdName];

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

    self.tdId = [aDecoder decodeDoubleForKey:kTestDirectionBaseClassTdId];
    self.tdName = [aDecoder decodeObjectForKey:kTestDirectionBaseClassTdName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_tdId forKey:kTestDirectionBaseClassTdId];
    [aCoder encodeObject:_tdName forKey:kTestDirectionBaseClassTdName];
}

- (id)copyWithZone:(NSZone *)zone
{
    TestDirectionBaseClass *copy = [[TestDirectionBaseClass alloc] init];
    
    if (copy) {

        copy.tdId = self.tdId;
        copy.tdName = [self.tdName copyWithZone:zone];
    }
    
    return copy;
}


@end
