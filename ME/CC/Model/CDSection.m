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
    
    NSArray *array = [dic[@"CScontent"] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1[@"courseID"] compare:obj2[@"courseID"]];
    }];
    //NSLog(@"%@",array);
    cs.csContent = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (NSInteger i=0; i<array.count; i++) {
        CDsectionContent *content = [[CDsectionContent alloc] init];
        content.courseID = [[array[i] objectForKey:@"courseID"] integerValue];
        content.courseName = [array[i] objectForKey:@"courseName"];
        content.courseImageUrl = [array[i] objectForKey:@"courseImageUrl"];
        [cs.csContent addObject:content];
        //NSLog(@"%@",cs.csContent);
    }
    

    
    return cs;
}

@end
