//
//  UserIntegralModel.m
//  ME
//
//  Created by Johnny's on 14-8-13.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "UserIntegralModel.h"
#import "User.h"

#define kuTime @"uTime"
#define kuserId @"userId"
#define kisSign @"isSign"
#define ktestCount @"testCount"

@implementation NSURL (doc)

+ (NSString *)applicationDocumentsDirectory
{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) [0];
}

@end


@implementation UserIntegralModel


#pragma mark-NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_uTime forKey:kuTime];
    [aCoder encodeInt:_userId forKey:kuserId];
    [aCoder encodeBool:_isSign forKey:kisSign];
    [aCoder encodeInt:_testCount forKey:ktestCount];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self == [super init]) {
        _uTime =  [aDecoder decodeObjectForKey:kuTime];
        _userId = [aDecoder decodeIntForKey:kuserId];
        _testCount = [aDecoder decodeIntForKey:ktestCount];
        _isSign = [aDecoder decodeBoolForKey:kisSign];
    }
    
    return self;
}

- (UserIntegralModel *)queryModels
{
    UserIntegralModel * model = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getFilePath]];
    return model;
}

- (void)saveDirectionModel:(UserIntegralModel *)paramModel
{
    [NSKeyedArchiver archiveRootObject:paramModel toFile:[self getFilePath]];
}

-(NSString *)getFilePath{
    //    NSString *string = [[NSURL applicationDocumentsDirectory] stringByAppendingPathComponent:@"CZX.Me"];
    User *user = [User sharedUser];
    NSString * dataBasePath = [[NSURL applicationDocumentsDirectory]
                               stringByAppendingPathComponent:
                               [NSString stringWithFormat:@"UserIntegral%d.arch", user.info.userId]];
    return dataBasePath;
}


@end
