//
//  TrendModel.h
//
//  Created by  C陈政旭 on 14-9-10
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TrendModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double hmtime;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) double userId;
@property (nonatomic, assign) double mid;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPortrait;
@property (nonatomic, strong) NSString *url;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
