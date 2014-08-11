//
//  CDownloadModel.h
//  ME
//
//  Created by yato_kami on 14-8-10.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol downloadDelegate <NSObject>
- (void)upDateUI;
//- (void)reloadDowloadUI;
@end

@interface CDownloadModel : NSObject

@property (strong) NSMutableArray *downloadArray; //下载信息数组
@property (strong, nonatomic) NSMutableDictionary *dOperationDic; //下载队列字典

@property (weak , nonatomic) id<downloadDelegate> myDelegate;

- (void)downLoadVideoWithUrlString:(NSString *)urlString andName:(NSString *)name andCNum:(NSString *)num andVideoID:(NSString *)videoID;

+ (CDownloadModel *)sharedCDownloadModel;

- (void)pauseWithVideoID:(NSString *)videoID; //暂停
- (void)continueWithVideoID:(NSString *)videoID; //继续
- (void)deleteWithVideoID:(NSString *)videoID; //删除任务

@end
