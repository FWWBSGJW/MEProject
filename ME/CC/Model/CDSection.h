//
//  CDSection.h
//  ME
//
//  Created by yato_kami on 14-7-21.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDsectionContent.h"
//课程方向 阶段信息类

@interface CDSection : NSObject
//阶段number
@property (assign, nonatomic) NSInteger csNum;
//阶段名称
@property (strong, nonatomic) NSString *csName;
//阶段内容数组 存取CDsectionContent对象
@property (strong, nonatomic) NSMutableArray *csContent;


//实例化方法
+ (instancetype)courseSectionWithDictionary:(NSDictionary *)dic;

@end
