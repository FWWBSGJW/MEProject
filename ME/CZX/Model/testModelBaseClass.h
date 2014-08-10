//
//  testModelBaseClass.h
//
//  Created by  C陈政旭 on 14-8-10
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface testModelBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *tcName;
@property (nonatomic, assign) double tcId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
