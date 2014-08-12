//
//  UserInfo.h
//  Online_learning
//
//  Created by qf on 14/7/7.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ListInfo.h"
@interface UserInfo :NSObject
@property (nonatomic)		 NSUInteger	userId;
@property (nonatomic,strong) NSDictionary *data;
@property (nonatomic,strong) NSString	*account;	//账号
@property (nonatomic,strong) NSString	*name;		//昵称
@property (nonatomic,readonly)	BOOL	sex;		//性别
@property (nonatomic,strong) NSString	*imageUrl;	//头像
@property (nonatomic,strong) NSString	*describe;	//个性签名
@property (nonatomic,readonly)	BOOL	isLogin;	//登陆状态

@property (nonatomic,strong) ListInfo		*lcourses;  //正在学习的课程 （有进度的)

@property (nonatomic,strong) ListInfo		*ccourses;	//收藏的课程

@property (nonatomic,strong) ListInfo		*bcourses;	//已购买课程

@property (nonatomic,strong) ListInfo		*focus;		//我关注的人

@property (nonatomic,strong) ListInfo		*focused;	//关注我的人

@property (nonatomic,strong) ListInfo		*questions;	//我的提问

@property (nonatomic,strong) ListInfo		*answers;	//我的回答

@property (nonatomic,strong) ListInfo		*testcollection;		//收藏的测试

- (BOOL)userLoginWith:(NSString *)userName andPassword:(NSString *)passWord;
//判断用户名和密码 进行登录  成功返回YES 并将isLogin 改为YES
- (BOOL)userLogout; //登出
- (void)update;
- (id)initWithUserId:(NSInteger)userId;
- (BOOL)refresh;
@end
