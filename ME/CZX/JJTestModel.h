//
//  JJTestModel.h
//  在线教育
//
//  Created by Johnny's on 14-7-9.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJTestModel : NSObject

@property(nonatomic ,copy) NSString *TimgUrl;
@property(nonatomic ,copy) NSString *Tprice;
@property(nonatomic) int Ttimes;
@property(nonatomic ,copy) NSString *Tdirection;
@property(nonatomic) int Tduration;
@property(nonatomic) int Tamount;
@property(nonatomic) int Tpoints;


@end
