//
//  JJCommentModel.h
//
//  Created by  C陈政旭 on 14-7-29
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface JJCommentModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double ccId;
@property (nonatomic, strong) NSString *userPortrait;
@property (nonatomic, strong) NSString *userSign;
@property (nonatomic, assign) double userid;
@property (nonatomic, strong) NSString *ccContent;
@property (nonatomic, strong) NSString *ccDate;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
