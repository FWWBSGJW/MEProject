//
//  MoveCommentModel.h
//
//  Created by  C陈政旭 on 14-9-10
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MoveCommentModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *userPortrait;
@property (nonatomic, strong) NSString *userName;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
