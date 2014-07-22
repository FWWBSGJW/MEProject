//
//  CDsectionContent.h
//  ME
//
//  Created by yato_kami on 14-7-22.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDsectionContent : NSObject
//课程id
@property (assign, nonatomic) NSInteger courseID;
//课程name
@property (strong, nonatomic) NSString *courseName;
//课程图片url
@property (strong, nonatomic) NSString *courseImageUrl;
//缓存图片
@property (strong, nonatomic) UIImage *cacheImage;

@end
