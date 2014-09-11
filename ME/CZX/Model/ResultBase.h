//
//  ResultBase.h
//
//  Created by  C陈政旭 on 14-9-11
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ResultBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *cName;
@property (nonatomic, strong) NSString *userPortrait;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) double userId;
@property (nonatomic, strong) NSString *cPic;
@property (nonatomic, assign) double cid;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
