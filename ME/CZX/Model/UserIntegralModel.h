//
//  UserIntegralModel.h
//  ME
//
//  Created by Johnny's on 14-8-13.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserIntegralModel : NSObject

@property(nonatomic ,copy) NSString *uTime;
@property(nonatomic) int userId;
@property(nonatomic) BOOL isSign;
@property(nonatomic) int testCount;


- (UserIntegralModel *)queryModels;
- (void)saveDirectionModel:(UserIntegralModel *)paramModel;

@end
