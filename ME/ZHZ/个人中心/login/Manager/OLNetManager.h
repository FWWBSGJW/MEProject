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
 *  使用userid获取对应信息
 *
 *  @param userId
 *
 *  @return 用户信息dic
 */
+ (NSDictionary *)userDataWithId:(NSString *)userId;
/**
 *  删除收藏的测试
 *
 *  @param userid testid
 *
 *  @return 返回bool结果
 */
+ (BOOL)deleteCollectionTestWithUserId:(NSString *)userId andTestId:(NSString *)testId;
/**
 *  删除收藏的课程
 *
 *  @param userid courseid
 *
 *  @return 返回bool结果
 */
+ (NSInteger)privateWithCourseID:(NSInteger)courseID andUserID:(NSString *)userID;
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
