//
//  SubjectController.h
//  ME
//
//  Created by Johnny's on 14-7-25.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubjectController : UIViewController

- (id)initWithCorrectAnswer:(NSArray *)correctArray personAnswer:(NSArray *)personArray questionArray:(NSArray *)queArray answerArray:(NSArray *)anArray page:(int)parmaPage;

@property(nonatomic, strong) UIButton *upBtn;
@property(nonatomic, strong) UIButton *downBtn;

@end
