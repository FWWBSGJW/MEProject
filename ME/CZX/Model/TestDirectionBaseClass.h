//
//  TestDirectionBaseClass.h
//
//  Created by  C陈政旭 on 14-8-10
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TestDirectionBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double tdId;
@property (nonatomic, strong) NSString *tdName;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
