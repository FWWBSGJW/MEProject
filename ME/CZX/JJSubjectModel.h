//
//  JJSubjectModel.h
//  ME
//
//  Created by Johnny's on 14-7-24.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJSubjectModel : NSObject

@property(nonatomic ,copy) NSString *ceAnswer;
@property(nonatomic ,copy) NSString *ceContext;
@property(nonatomic)int ceId;
@property(nonatomic, strong) NSMutableArray *options;

- (void)setSubjectModelWithDictionary:(NSDictionary *)dict;
@end
