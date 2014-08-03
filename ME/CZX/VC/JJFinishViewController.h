//
//  JJFinishViewController.h
//  在线教育
//
//  Created by Johnny's on 14-7-11.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "JJBaseViewController.h"

@interface JJFinishViewController : JJBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *scoreLa;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *timeLa;

- (id)initWithScore:(NSString *)score correctAnswer:(NSArray *)correctArray personAnswer:(NSArray *)personArray questionArray:(NSArray *)queArray answerArray:(NSArray *)anArray costMins:(int)paramMins costSeconds:(int)paramSeconds;
@property (strong, nonatomic) IBOutlet UIButton *reviewBtn;
@property (strong, nonatomic) IBOutlet UIView *scoreView;
@property (nonatomic, copy) NSString *highScoreUrl;
@property(nonatomic, strong) UITableView *scoreTableView;
@property(nonatomic, strong) NSArray *scoreArray;
- (IBAction)wrongSubject:(id)sender;
@property(nonatomic, strong) UIActivityIndicatorView *activityView;
- (void)achieveScoreView;
@end
