//
//  WrongSubjectViewController.h
//  ME
//
//  Created by Johnny's on 14-8-2.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WrongSubjectViewController : UIViewController

- (id)initWithWrongSubjectArray:(NSArray *)wrongArray;
@property(nonatomic, strong) NSMutableArray *wrongSubjectArray;
@property(nonatomic, strong) NSMutableArray *correctAnswerArray;
@property(nonatomic, strong) NSMutableArray *questionArray;
@property(nonatomic, strong) NSMutableArray *answerArray;
@property(nonatomic, strong) NSMutableArray *numberCorrectAnswerArray;
@property(nonatomic, strong) UITableView *tableView;
@end
