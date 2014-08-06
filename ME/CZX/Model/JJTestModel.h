//
//  JJTestModel.h
//  在线教育
//
//  Created by Johnny's on 14-7-9.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJTestModel : NSObject

@property(nonatomic ,copy) NSString *highScoreUrl;
@property(nonatomic ,copy) NSString *commentLink;
@property(nonatomic) int subjectnums;
@property(nonatomic ,copy) NSString *sublink;
@property(nonatomic) int tcId;
@property(nonatomic ,copy) NSString *tcIntro;
@property(nonatomic ,copy) NSString *tcName;
@property(nonatomic ,copy) NSString *tcPhotoUrl;
@property(nonatomic) int tcNum;
@property(nonatomic) int tcPrice;
@property(nonatomic) int tcScore;
@property(nonatomic) int tcTime;
@property(nonatomic) int tdirection;
@property(nonatomic ,copy) NSString *nextPage;

- (void)setTestModelWithDictionary:(NSDictionary *)dict;
@end
