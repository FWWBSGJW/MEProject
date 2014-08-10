//
//  FightModelBaseClass.h
//
//  Created by  C陈政旭 on 14-8-10
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface FightModelBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double cDid;
@property (nonatomic, strong) NSString *cDhead;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
