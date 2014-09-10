//
//  GetAndPayModel.m
//  ME
//
//  Created by yato_kami on 14-8-11.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//  

#import "GetAndPayModel.h"
#import "CAlertLabel.h"

#define noteTimes 5
#define commentTimes 5
#define videoTimes 5
#define danmakuTimes 10
#define shareTimes 5

@implementation GetAndPayModel
//http://121.197.10.159:8080/MobileEducation/uploadPoints?points=1&userId=1
#pragma mark - getter and setter
- (NSMutableArray *)userCoinArray
{
    if (!_userCoinArray) {
        NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *Path = [doc[0] stringByAppendingPathComponent:@"userCoinArray.plist"];
        _userCoinArray =  [NSMutableArray arrayWithContentsOfFile:Path];
        if (_userCoinArray == nil) {
            _userCoinArray = [NSMutableArray array];
        }
    }
    return _userCoinArray;
}



- (void)getCoinWithCount:(NSInteger)count andUserID:(NSInteger)userID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@MobileEducation/uploadPoints?points=%d&userId=%d",kBaseURL,count,userID]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //NSLog(@"获得积分");
        NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *Path = [doc[0] stringByAppendingPathComponent:@"userCoinArray.plist"];
        [self.userCoinArray writeToFile:Path atomically:YES];
    }];
    
}
- (NSMutableDictionary *)userCheckForUserID:(NSInteger)userID
{
    BOOL haveUser = NO;
    NSMutableDictionary *userDic;
    for (NSMutableDictionary *dic in self.userCoinArray) {
        if ([dic[@"userID"] integerValue] == userID) {
            userDic = dic;
            haveUser = YES;
    
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [formatter stringFromDate:date];
            if (![dateStr isEqualToString:userDic[@"myDate"]]) {
                userDic[@"noteCointNum"] = @0;
                userDic[@"commentCoinNum"] = @0;
                userDic[@"videoCoinNum"] = @0;
                userDic[@"danmakuCoinNum"] = @0;
                userDic[@"shareCoinNum"] = @0;
                userDic[@"myDate"] = dateStr;
            }
            break;
        }
    }
    if (!haveUser) {
        userDic = [NSMutableDictionary dictionary];
        [userDic setObject:[NSNumber numberWithInteger:userID] forKey:@"userID"];
        [userDic setObject:@0 forKey:@"noteCointNum"];
        [userDic setObject:@0 forKey:@"commentCoinNum"];
        [userDic setObject:@0 forKey:@"videoCoinNum"];
        [userDic setObject:@0 forKey:@"danmakuCoinNum"];
        [userDic setObject:@0 forKey:@"shareCoinNum"];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [formatter stringFromDate:date];
        [userDic setObject:dateStr forKey:@"myDate"];
        
        [self.userCoinArray addObject:userDic];
    }
    return userDic;
}

#pragma mark 笔记积分
- (NSInteger)getCoinForNoteWithUserID:(NSInteger)userID
{
    NSMutableDictionary *userDic = [self userCheckForUserID:userID];
    
    if ([userDic[@"noteCoinNum"] integerValue] < noteTimes) {
        [self getCoinWithCount:1 andUserID:userID];
        userDic[@"noteCoinNum"] = [NSNumber numberWithInteger:[userDic[@"noteCoinNum"] integerValue]+1];
        return 1;
        //CAlertLabel *alert = [CAlertLabel alertLabelWithAdjustFrameForText:@"你获得了1积分"];
        //[alert showAlertLabel];
    }
    return 0;
}

#pragma mark 评论积分
- (NSInteger)getCoinForCommentWithUserID:(NSInteger)userID
{
    NSMutableDictionary *userDic = [self userCheckForUserID:userID];
    
    if ([userDic[@"commentCoinNum"] integerValue] < commentTimes) {
        [self getCoinWithCount:1 andUserID:userID];
        userDic[@"commentCoinNum"] = [NSNumber numberWithInteger:[userDic[@"commentCoinNum"] integerValue]+1];
        //CAlertLabel *alert = [CAlertLabel alertLabelWithAdjustFrameForText:@"你获得了1积分"];
        //[alert showAlertLabel];
        return 1;
    }
    return 0;
}

#pragma mark 视频积分
- (void)getCoinForVideoWithUserID:(NSInteger)userID
{
    NSMutableDictionary *userDic = [self userCheckForUserID:userID];
    if ([userDic[@"videoCoinNum"] integerValue] < videoTimes) {
        userDic[@"videoCoinNum"] = [NSNumber numberWithInteger:[userDic[@"videoCoinNum"] integerValue]+1];
        [self getCoinWithCount:1 andUserID:userID];
        //CAlertLabel *alert = [CAlertLabel alertLabelWithAdjustFrameForText:@"你获得了1积分"];
        //[alert showAlertLabel];
    }
}

#pragma mark 弹幕积分
- (void)getCoinForDanmakuWithUserID:(NSInteger)userID WithSendedNum:(NSInteger)sendNum
{
    NSMutableDictionary *userDic = [self userCheckForUserID:userID];
    NSInteger hadGetNum = [userDic[@"danmakuCoinNum"] integerValue];
    if ( hadGetNum < danmakuTimes) {
        NSInteger addNum = (danmakuTimes - hadGetNum > sendNum ? sendNum:danmakuTimes-hadGetNum);
        userDic[@"danmakuCoinNum"] = [NSNumber numberWithInteger:hadGetNum+addNum];
        [self getCoinWithCount:addNum andUserID:userID];
    }
}
#pragma mark 分享
- (void)getCoinForShareWithUserID:(NSInteger)userID
{
    NSMutableDictionary *userDic = [self userCheckForUserID:userID];
    if ([userDic[@"shareCoinNum"] integerValue] < shareTimes) {
        userDic[@"shareCoinNum"] = [NSNumber numberWithInteger:[userDic[@"shareCoinNum"] integerValue]+1];
        [self getCoinWithCount:1 andUserID:userID];
    }
}

@end
