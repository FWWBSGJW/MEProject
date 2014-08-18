//
//  ListInfo.h
//  ME
//
//  Created by qf on 14/8/10.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListInfo : NSObject
@property (nonatomic,strong) NSDictionary *data;

@property (nonatomic) NSUInteger count;		//数目
@property (nonatomic,strong) NSString *link;	//详细内容的链接
@property (nonatomic,strong) NSMutableArray *courses;	//预览课程
@property (nonatomic,strong) NSMutableArray *linkContent;
@property (nonatomic,strong)	NSMutableArray *values;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
- (void)refreshLinkContent;
@end
