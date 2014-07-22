//
//  CDSection.m
//  ME
//
//  Created by yato_kami on 14-7-21.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "CDSection.h"

@implementation CDSection

+ (instancetype)courseSectionWithDictionary:(NSDictionary *)dic
{
    CDSection *cs = [[CDSection alloc] init];
    cs.csNum = [dic[@"CSnum"] integerValue];
    cs.csName = dic[@"CSname"];
    cs.csContent = dic[@"CScontent"];
    
    cs.csCacheImageArray = [NSMutableArray arrayWithCapacity:cs.csContent.count];
    
//    for (NSInteger i=0; i<cs.csContent.count; i++) {
//        [cs.csCacheImageArray addObject:[[UIImage alloc] init]];
//    }
    
    return cs;
}

@end
