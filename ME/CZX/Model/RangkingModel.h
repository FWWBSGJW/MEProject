//
//  RangkingModel.h
//
//  Created by  C陈政旭 on 14-8-2
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface RangkingModel : NSObject

@property (nonatomic, strong) NSString *userPortrait;
@property (nonatomic, assign) double score;
@property (nonatomic, assign) double hmtime;
@property (nonatomic, assign) double hstime;
@property (nonatomic, assign) double userId;
@property (nonatomic, strong) NSString *userName;


//+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
//- (NSDictionary *)dictionaryRepresentation;

@end
