//
//  OLNetManager.h
//  Online_learning
//
//  Created by qf on 14/7/9.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#define SUCCESSBLOCK      void(^)(NSDictionary* successDict)
#define FAILUREBLOCK      void(^)(NSDictionary *failDict, NSError *error)
@interface OLNetManager : NSObject <NSURLConnectionDataDelegate>
+(NSData *)netRequestWithUrl:(NSString *)urlStr andPostBody:(NSString *)body;
/**
 *  登录
 *
 *  @param username 用户名 password 密码
 *
 *  @return 用户信息dic
 */
+ (NSDictionary *)loginWith:(NSString *)username
	  andPassword:(NSString *)password;
/**
 *  关注
 *
 *  @param userid
 *
 *  @return 关注用户userid 为关注的人的id  -1;//要关注的用户不存在	  1;//关注用户成功 2;//取消关注成功 -2;//不能关注自己 -3;//用户没有输入要关注的人
 */
+ (NSInteger)focusUserWithUserId:(NSInteger)userId;
/**
 *  使用userid获取对应信息
 *
 *  @param userId
 *
 *  @return 用户信息dic
 */
+ (NSDictionary *)userDataWithId:(NSInteger)userId;
/**
 *  删除收藏的测试
 *
 *  @param userid testid
 *
 *  @return 返回bool结果
 */
+ (BOOL)deleteCollectionTestWithUserId:(NSInteger)userId andTestId:(NSString *)testId;
/**
 *  删除收藏的课程
 *
 *  @param userid courseid
 *
 *  @return 返回bool结果
 */
+ (NSInteger)privateWithCourseID:(NSInteger)courseID andUserID:(NSInteger)userID;
/**
 *  注册
 *
 *  @param username account pwd
 *
 *  @return 返回 -4;//用户填信息不全-3;//昵称已存在-2;//用户名已存在 1;//注册成功
 */
+ (NSInteger)userRegisterWithUserName:(NSString *)username
						  userAccount:(NSString *)account
						   andUserPwd:(NSString *)pwd;
@end
