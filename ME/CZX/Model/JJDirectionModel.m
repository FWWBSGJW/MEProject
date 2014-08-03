//
//  JJDirectionModel.m
//  在线教育
//
//  Created by Johnny's on 14-7-23.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "JJDirectionModel.h"
#import "UIImageView+WebCache.h"
#define klinkKey @"link"
#define ktdIdKey @"tdId"
#define ktdName @"tdName"
#define ktdDetail @"tdDetail"
#define ktdPic @"tdPic"
#define ktdpersonnum @"tdpersonnum"
#define ktestnum @"testnum"
#define kdirectionImage @"directionImage"

@implementation JJDirectionModel

- (void)setDirectionModelWithDictionary:(NSDictionary *)dict
{
    _link = [dict objectForKey:@"link"];
    _tdId = [[dict objectForKey:@"tdId"] intValue];
    _tdName = [dict objectForKey:@"tdName"];
    _tdDetail = [dict objectForKey:@"tdDetail"];
    _tdPic = [dict objectForKey:@"tdPic"];
    _tdpersonnum = [[dict objectForKey:@"tdpersonnum"] intValue];
    _testnum = [[dict objectForKey:@"testnum"] intValue];
    _directionImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, _tdPic]]]];
}

#pragma mark-NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    
    [aCoder encodeObject:_link forKey:klinkKey];
    [aCoder encodeInt:_tdId forKey:ktdIdKey];
    [aCoder encodeObject:_tdName forKey:ktdName];
    [aCoder encodeObject:_tdDetail forKey:ktdDetail];
    [aCoder encodeObject:_tdPic forKey:ktdPic];
    [aCoder encodeInt:_tdpersonnum forKey:ktdpersonnum];
    [aCoder encodeInt:_testnum forKey:ktestnum];
    [aCoder encodeObject:_directionImage forKey:kdirectionImage];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self == [super init]) {
        _link =  [aDecoder decodeObjectForKey:klinkKey];
        _tdId = [aDecoder decodeIntForKey:ktdIdKey];
        _tdName =  [aDecoder decodeObjectForKey:ktdName];
        _tdDetail =  [aDecoder decodeObjectForKey:ktdDetail];
        _tdPic =  [aDecoder decodeObjectForKey:ktdPic];
        _tdpersonnum = [aDecoder decodeIntForKey:ktdpersonnum];
        _testnum = [aDecoder decodeIntForKey:ktestnum];
        _directionImage = [aDecoder decodeObjectForKey:kdirectionImage];
    }
    
    return self;
}

#pragma mark-NSCopying
-(id)copyWithZone:(NSZone *)zone{
    JJDirectionModel *copy = [[[self class] allocWithZone:zone] init];
    copy.link = [self.link copyWithZone:zone];
    copy.tdId = self.tdId;
    copy.tdName = [self.tdName copyWithZone:zone];
    copy.tdDetail = [self.tdDetail copyWithZone:zone];
    copy.tdPic = [self.tdPic copyWithZone:zone];
    copy.tdpersonnum = self.tdpersonnum;
    copy.testnum = self.testnum;
    copy.directionImage = self.directionImage;
    
    return copy;
}

@end
