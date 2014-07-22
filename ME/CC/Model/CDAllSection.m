//
//  CDAllSection.m
//  ME
//
//  Created by yato_kami on 14-7-21.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "CDAllSection.h"


@implementation CDAllSection

- (void)loadDataWithCDid:(NSInteger)cdID
{
    self.cdID = cdID;
    
    NSLog(@"加载课程方向阶段数据");
    NSString *string = [NSString stringWithFormat:@"MobileEducation/courseAction?Did=%d",self.cdID];
    NSString *str = [kBaseURL stringByAppendingString:string];
    
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.5f];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //NSLog(@"%@",data);
    
    if (data != nil) {
        [self handleJSONData:data];
    } else if (data == nil && error == nil) {
        NSLog(@"空数据");
    } else {
        NSLog(@"%@",error.localizedDescription);
    }
    
}

- (void)handleJSONData:(NSData *)datda
{
    //反序列化
    NSArray *array = [NSJSONSerialization JSONObjectWithData:datda options:NSJSONReadingAllowFragments error:nil];
    
    //保存至沙箱，持久化
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docs[0] stringByAppendingPathComponent:@"CourseSectionData.plist"];
    [array writeToFile:path atomically:YES];
    
    NSMutableArray *cdAllSectionArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        
        CDSection *cdSection = [CDSection courseSectionWithDictionary:dic];
        [cdAllSectionArray addObject:cdSection];
        
    }
    self.cdAllSectionArray = cdAllSectionArray;
}
@end